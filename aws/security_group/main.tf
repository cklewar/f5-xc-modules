resource "aws_security_group" "sg" {
  tags        = var.custom_tags
  name        = var.aws_security_group_name
  vpc_id      = var.aws_vpc_id
  description = var.description
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  for_each          = {for idx, rule in local.egress : idx => rule}
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = each.value.cidr_ipv4
  from_port         = each.value.from_port
  ip_protocol       = each.value.ip_protocol
  to_port           = each.value.to_port
}

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  for_each          = {for idx, rule in local.ingress : idx => rule}
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = each.value.cidr_ipv4
  from_port         = each.value.from_port
  ip_protocol       = each.value.ip_protocol
  to_port           = each.value.to_port
}