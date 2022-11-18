variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_eks_cluster_name" {
  type = string
}

variable "aws_subnet_ids" {
  type = list(string)
}

variable "aws_eks_fabric_address_pool" {
  type    = string
  default = ""
}

variable "aws_vpc_zone_identifier" {
  description = "list of aws_subnet ids"
  type        = list(string)
}

variable "aws_vpc_id" {
  type = string
}

variable "aws_eks_worker_vm_count" {
  type    = number
  default = 1
}

variable "aws_disable_public_ip" {
  type    = bool
  default = false
}

variable "aws_route_table_id" {
  type    = string
  default = ""
}

variable "aws_endpoint_private_access" {
  type    = bool

}

variable "aws_endpoint_public_access" {
  type = bool
}

variable "iam_owner" {
  type = string
}