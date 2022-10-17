resource "aws_security_group" "sg" {
  name   = var.aws_security_group_name
  vpc_id = var.aws_vpc_id
  tags   = var.custom_tags

  dynamic "egress" {
    for_each = var.security_group_rule_egress
    content {
      from_port   = egress.from_port
      to_port     = egress.to_port
      protocol    = egress.protocol
      cidr_blocks = egress.cidr_block
    }
  }

  dynamic "ingress" {
    for_each = var.security_group_rule_ingress
    content {
      from_port   = ingress.from_port
      to_port     = ingress.to_port
      protocol    = ingress.protocol
      cidr_blocks = ingress.cidr_blocks
    }
  }
}