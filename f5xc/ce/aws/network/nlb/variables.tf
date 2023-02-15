variable "aws_nlb_subnets" {
  type = list(string)
}

variable "cluster_name" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "aws_vpc_id" {
  type = string
}