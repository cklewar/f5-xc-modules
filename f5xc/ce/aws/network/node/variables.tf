variable "common_tags" {
  type = map(string)
}

variable "has_public_ip" {
  type = bool
}

variable "f5xc_is_secure_or_private_cloud_ce" {
  type = bool
}

variable "aws_vpc_id" {
  type = string
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

variable "aws_sg_slo_ids" {
  type = list(string)
}

variable "aws_sg_sli_ids" {
  type = list(string)
}

variable "is_multi_nic" {
  type = bool
}

variable "aws_slo_subnet_rt_id" {
  type = string
}

variable "aws_sli_subnet_rt_id" {
  type = string
}

variable "aws_slo_static_ips" {
  type = list(string)
}

variable "node_name" {
  type = string
}

variable "owner_tag" {
  type = string
}

variable "aws_existing_slo_subnet_id" {
  type = string
}

variable "aws_existing_sli_subnet_id" {
  type = string
}

variable "create_new_aws_slo_rta" {
  type = bool
}

variable "create_new_aws_sli_rta" {
  type = bool
}