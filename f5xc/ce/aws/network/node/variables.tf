variable "has_public_ip" {
  type    = bool
  default = true
}

variable "aws_vpc_id" {
  type    = string
  default = ""
}

variable "aws_subnet_slo_cidr" {
  type = string
}

variable "aws_subnet_sli_cidr" {
  type = string
}

variable "aws_vpc_az" {
  type = string
}

variable "aws_eip_nat_gw_eip_id" {
  type = string
}

variable "aws_sg_slo_id" {
  type = string
}

variable "aws_sg_sli_id" {
  type = string
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

variable "cluster_name" {
  type = string
}

variable "owner_tag" {
  type = string
}