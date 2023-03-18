locals {
  egress = flatten([
    for rule in var.security_group_rules_egress : [
      for cidr_block in rule.cidr_blocks :
      {
        ip_protocol = rule.ip_protocol
        from_port   = rule.from_port
        to_port     = rule.to_port
        cidr_ipv4   = cidr_block
      }
    ]
  ])

  ingress = flatten([
    for rule in var.security_group_rules_ingress : [
      for cidr_block in rule.cidr_blocks :
      {
        ip_protocol = rule.ip_protocol
        from_port   = rule.from_port
        to_port     = rule.to_port
        cidr_ipv4   = cidr_block
      }
    ]
  ])
}