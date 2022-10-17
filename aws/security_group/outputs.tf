output "aws_security_group" {
  value = {
    id      = aws_security_group.sg.id
    name    = aws_security_group.sg.name
    egress  = aws_security_group.sg.egress
    ingress = aws_security_group.sg.ingress
    vpc_id  = aws_security_group.sg.vpc_id
  }
}