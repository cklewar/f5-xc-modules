variable "aws_region" {
  type = string
}

variable "aws_existing_vpc_id" {
  type    = string
  default = ""
}

variable "aws_vpc_enable_dns_support" {
  type    = bool
  default = true
}

variable "aws_vp_enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "aws_lb_type_nlb" {
  type    = string
  default = "network"
}

variable "aws_eip_vpc" {
  type    = bool
  default = true
}

variable "aws_vpc_subnet_prefix" {
  type = string
}

variable "aws_security_group_rule_slo_egress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "aws_security_group_rule_slo_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "aws_security_group_rule_sli_egress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "aws_security_group_rule_sli_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "f5xc_ce_gateway_type_ingress" {
  type    = string
  default = "ingress_gateway"
}

variable "f5xc_ce_gateway_type_ingress_egress" {
  type    = string
  default = "ingress_egress_gateway"
}

variable "f5xc_ce_gateway_type" {
  type = string
}

variable "f5xc_aws_vpc_az_nodes" {
  type = map(map(string))
}

variable "service_port" {
  type    = string
  default = "6443"
}

variable "ver_rest_port" {
  type    = string
  default = "8005"
}

variable "ver_grpc_port" {
  type    = string
  default = "8505"
}

variable "cluster_name" {
  type = string
}

variable "owner_tag" {
  type = string
}