variable "aws_eks_cluster_name" {
  type = string
}

variable "aws_subnet_ids" {
  type = list(string)
}

variable "eks_version" {
  type    = string
  default = "1.19"
}