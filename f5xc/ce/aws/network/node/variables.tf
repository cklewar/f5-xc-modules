variable "common_tags" {
  type = map(string)
}

variable "has_public_ip" {
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

variable "node_name" {
  type = string
}

variable "owner_tag" {
  type = string
}

variable "f5xc_is_secure_cloud_ce" {
  type = bool
}