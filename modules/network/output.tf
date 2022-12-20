
output "elb-dns-name" {
  value = aws_lb.lb.dns_name
}
output "vpc_id" {
    value=aws_vpc.vpc.id
}

output "sg_id" {
    value=aws_security_group.sg.id
}
output "sn_ids" {
  value=aws_subnet.sn.*.id
}