variable "aws_region" {
  type = string
}

variable "aws_az_name" {
  type = string
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "instance_tenancy" {
  type    = string
  default = "default"
}

variable "aws_vpc_cidr_block" {
  type = string
}

variable "aws_vpc_name" {
  type = string
}

variable "aws_owner" {
  type = string
}

variable "custom_tags" {
  description = "Custom tags to set on resources"
  type        = map(string)
  default     = {}
}