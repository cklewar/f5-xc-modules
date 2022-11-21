output "aws_eks" {
  value = {
    "id"                        = aws_eks_cluster.k8s.id
    "name"                      = aws_eks_cluster.k8s.name
    "tags"                      = aws_eks_cluster.k8s.tags
    "vpc_id"                    = aws_vpc.vpc.id
    "version"                   = aws_eks_cluster.k8s.version
    "vpc_config"                = aws_eks_cluster.k8s.vpc_config
    "kubeconfig"                = abspath("${path.root}/${local_file.kubeconfig.filename}")
    "node_group_id"             = aws_eks_node_group.k8s.id
    "platform_version"          = aws_eks_cluster.k8s.platform_version
    "kubernetes_network_config" = aws_eks_cluster.k8s.kubernetes_network_config
  }
}