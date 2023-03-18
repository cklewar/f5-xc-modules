output "aws_security_group" {
  value = {
    id      = aws_security_group.sg.id
    name    = aws_security_group.sg.name
    egress  = aws_vpc_security_group_egress_rule.egress
    ingress = aws_vpc_security_group_ingress_rule.ingress
    vpc_id  = aws_security_group.sg.vpc_id
  }
}