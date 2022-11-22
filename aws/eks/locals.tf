locals {
  kubeconfig = templatefile("${path.module}/templates/kubeconfig.tftpl", {
    cluster_name = var.aws_eks_cluster_name,
    clusterca    = data.aws_eks_cluster.default.certificate_authority[0].data,
    endpoint     = data.aws_eks_cluster.default.endpoint,
  })
}