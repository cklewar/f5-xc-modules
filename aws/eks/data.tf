data "aws_eks_cluster" "default" {
  depends_on = [aws_eks_cluster.eks]
  name       = var.aws_eks_cluster_name
}

data "aws_eks_cluster_auth" "default" {
  depends_on = [aws_eks_cluster.eks]
  name       = var.aws_eks_cluster_name
}