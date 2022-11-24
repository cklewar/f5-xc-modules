variable "aws_eks_cluster_name" {
  type = string
}

variable "aws_vpc_cidr_block" {
  type    = string
  default = ""
}

variable "aws_vpc_subnet_a" {
  type    = string
  default = ""
}

variable "aws_vpc_subnet_b" {
  type    = string
  default = ""
}

variable "aws_region" {
  type = string
}

variable "aws_az_name" {
  type = string
}

variable "owner" {
  type = string
}

variable "custom_tags" {
  type    = map(string)
  default = {}
}

variable "aws_az_a" {
  type    = string
  default = "a"
}

variable "aws_az_b" {
  type    = string
  default = "b"
}

variable "aws_existing_subnet_ids" {
  type    = list(string)
  default = []
}

variable "eks_version" {
  type    = string
  default = "1.24"
}

variable "aws_eks_endpoint_private_access" {
  type    = bool
  default = false
}