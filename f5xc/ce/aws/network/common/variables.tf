variable "owner_tag" {
  type = string
}

variable "aws_vp_enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "aws_existing_vpc_id" {
  type    = string
  default = ""
}

variable "aws_vpc_enable_dns_support" {
  type    = bool
  default = true
}

variable "aws_vpc_subnet_prefix" {
  type = string
}