module "aws_eks" {
  source               = "./eks"
  aws_eks_cluster_name = var.aws_eks_cluster_name
}

module "k8s" {
  source       = "./k8s"
  cluster_name = module.aws_eks.aws_eks["name"]
}