module "aws_eks" {
  source               = "./eks"
  owner                = var.owner
  aws_region           = var.aws_region
  aws_az_name          = var.aws_az_name
  aws_vpc_subnet_a     = var.aws_vpc_subnet_a
  aws_vpc_subnet_b     = var.aws_vpc_subnet_b
  aws_vpc_cidr_block   = var.aws_vpc_cidr_block
  aws_eks_cluster_name = var.aws_eks_cluster_name
}

module "k8s" {
  source       = "./k8s"
  cluster_name = module.aws_eks.aws_eks["name"]
}