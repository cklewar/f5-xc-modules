data "aws_availability_zones" "available" {}

data "aws_vpc" "eks_vpc_data" {
  id = var.aws_vpc_id
}

data "aws_ami" "eks_worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.eks.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"]
}