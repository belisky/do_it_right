#vpc nobel-vpc-1
resource "aws_vpc" "vpc" {
  cidr_block=var.vpc_cidr
  instance_tenancy=var.instance_tenancy
  tags=var.tags
} 
#Internet Gateway

resource "aws_internet_gateway" "igw" {
    vpc_id=aws_vpc.vpc.id
}

#two public subnets

resource "aws_subnet" "sn" {
  count =var.env=="prod"?length(var.subnet_cidrs_public):1

  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = element(var.sn_cidr_block,count.index)
  availability_zone = "${var.az[count.index]}"
  map_public_ip_on_launch = true
    tags = {
    Name = "Subnet-${count.index+1}"
  }
}

#Route table
resource "aws_route_table" "rt" {
    vpc_id = "${aws_vpc.vpc.id}"
    route {
        cidr_block="0.0.0.0/0"
        gateway_id= aws_internet_gateway.igw.id
    }
    tags=var.tags
} 

resource "aws_route_table_association" "rta" {
  count =var.env=="prod"?length(var.subnet_cidrs_public):1

  subnet_id = "${element(aws_subnet.sn.*.id, count.index)}"
  route_table_id = "${aws_route_table.rt.id}"
}

 
# Create a new load balancer
resource "aws_lb" "lb" {
  name               = "nobel-lb"
  internal           = false
  load_balancer_type = "application"
  subnets         = aws_subnet.sn.*.id
  security_groups = ["${aws_security_group.sg.id}"]
}
resource "aws_lb_listener" "lbl" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"
  

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "tf-nobel-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}
resource "aws_lb_target_group_attachment" "tga" {
  count =var.env=="prod"?length(var.subnet_cidrs_public):1
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = element(var.ec2_ids.*, count.index)
  port             = 80
}

# Security Groups

#Common security group rules
resource "aws_security_group_rule" "ingress_rules" {
  count = length(var.ingress_rules)
  
  type              = "ingress"
  from_port         = var.ingress_rules[count.index].from_port
  to_port           = var.ingress_rules[count.index].to_port
  protocol          = var.ingress_rules[count.index].protocol
  cidr_blocks       = [var.ingress_rules[count.index].cidr_block]
  description       = var.ingress_rules[count.index].description
  security_group_id = aws_security_group.sg.id
}

#Security group rule for instance,load-balancer
resource "aws_security_group" "sg" {
  name        = "allow_ssh_n_http"
  description = "Allow ssh and http inbound traffic"
  vpc_id      = aws_vpc.vpc.id
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_conn"
  }
}

 