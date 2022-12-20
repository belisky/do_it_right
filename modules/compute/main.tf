

resource "aws_instance" "ec2" {
  count         = length(var.subnet_cidrs_public)
  instance_type = var.instance_type
  ami           = var.ami

  security_groups = [var.sg_id]
  subnet_id       = element(var.sn_ids.*, count.index)
  user_data       = file("install_docker.sh")

  tags = var.tags
}
 