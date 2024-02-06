variable "common_tags" {
  type = map(string)
}

variable "f5xc_node_name" {
  type = string
}

variable "slo_subnet_rt_id" {
  type = string
}

variable "slo_subnet_id" {
  type = string
}

variable "aws_vpc_nat_gw_subnet" {
  type = string
}

variable "aws_vpc_az" {
  type = string
}

variable "aws_vpc_id" {
  type = string
}