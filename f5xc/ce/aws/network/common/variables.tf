variable "f5xc_cluster_name" {
  type = string
}

variable "is_multi_nic" {
  type = bool
}

variable "common_tags" {
  type = map(string)
}

variable "owner_tag" {
  type = string
}

variable "aws_vp_enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "create_new_aws_vpc" {
  type = bool
}

variable "aws_existing_vpc_id" {
  type = string
}

variable "aws_vpc_enable_dns_support" {
  type    = bool
  default = true
}

variable "aws_vpc_cidr_block" {
  type = string
}

variable "aws_security_group_rules_slo_ingress_secure_ce" {
  type = list(object({
    from_port   = string
    to_port     = string
    ip_protocol = string
    cidr_blocks = list(string)
  }))
}

variable "aws_security_group_rules_slo_egress_secure_ce" {
  type = list(object({
    from_port   = string
    to_port     = string
    ip_protocol = string
    cidr_blocks = list(string)
  }))
}

variable "aws_security_group_rules_slo_egress_secure_ce_extended" {
  type = list(object({
    from_port   = string
    to_port     = string
    ip_protocol = string
    cidr_blocks = list(string)
  }))
}

variable "aws_security_group_rules_sli_egress_secure_ce" {
  type = list(object({
    from_port   = string
    to_port     = string
    ip_protocol = string
    cidr_blocks = list(string)
  }))
}

variable "aws_security_group_rules_sli_ingress_secure_ce" {
  type = list(object({
    from_port   = string
    to_port     = string
    ip_protocol = string
    cidr_blocks = list(string)
  }))
}

variable "aws_security_group_rules_slo_egress" {
  type = list(object({
    from_port   = string
    to_port     = string
    ip_protocol = string
    cidr_blocks = list(string)
  }))
}

variable "aws_security_group_rules_slo_ingress" {
  type = list(object({
    from_port   = string
    to_port     = string
    ip_protocol = string
    cidr_blocks = list(string)
  }))
}

variable "aws_security_group_rules_sli_egress" {
  type = list(object({
    from_port   = string
    to_port     = string
    ip_protocol = string
    cidr_blocks = list(string)
  }))
}

variable "aws_security_group_rules_sli_ingress" {
  type = list(object({
    from_port   = string
    to_port     = string
    ip_protocol = string
    cidr_blocks = list(string)
  }))
}

variable "f5xc_is_secure_cloud_ce" {
  type = bool
}

variable "f5xc_ce_slo_enable_secure_sg" {
  type    = bool
}