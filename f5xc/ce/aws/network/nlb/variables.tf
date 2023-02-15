variable "aws_vpc_id" {
  type = string
}

variable "aws_nlb_subnets" {
  type = list(string)
}

variable "f5xc_cluster_name" {
  type = string
}

variable "common_tags" {
  type = map(string)
}