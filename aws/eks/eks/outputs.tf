output "aws_eks" {
  value = {
    "id"                        = aws_eks_cluster.k8s.id
    "name"                      = aws_eks_cluster.k8s.name
    "tags"                      = aws_eks_cluster.k8s.tags
    "vpc_id"                    = module.aws_vpc.aws_vpc["id"]
    "version"                   = aws_eks_cluster.k8s.version
    "vpc_config"                = aws_eks_cluster.k8s.vpc_config
    "node_group_id"             = aws_eks_node_group.k8s.id
    "platform_version"          = aws_eks_cluster.k8s.platform_version
    "kubernetes_network_config" = aws_eks_cluster.k8s.kubernetes_network_config
    "subnets"                   = {
      format("%s-snet-a", var.aws_eks_cluster_name) = {
        "id"     = module.aws_subnet.aws_subnets[format("%s-snet-a", var.aws_eks_cluster_name)]["id"]
        "vpc_id" = module.aws_subnet.aws_subnets[format("%s-snet-a", var.aws_eks_cluster_name)]["vpc_id"]
      }
      format("%s-snet-b", var.aws_eks_cluster_name) = {
        "id"     = module.aws_subnet.aws_subnets[format("%s-snet-b", var.aws_eks_cluster_name)]["id"]
        "vpc_id" = module.aws_subnet.aws_subnets[format("%s-snet-b", var.aws_eks_cluster_name)]["vpc_id"]
      }
    }
  }
}