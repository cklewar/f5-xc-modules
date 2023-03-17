resource "aws_security_group" "sg" {
  tags        = var.custom_tags
  name        = var.aws_security_group_name
  vpc_id      = var.aws_vpc_id
  description = var.description

  dynamic "egress" {
    for_each = var.security_group_rule_egress
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  dynamic "ingress" {
    for_each = var.security_group_rule_ingress
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}