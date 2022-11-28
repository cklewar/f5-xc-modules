

output "aws_eks" {
  value = {
    "id"                        = aws_eks_cluster.eks.id
    "name"                      = aws_eks_cluster.eks.name
    "vpc_id"                    = length(var.aws_existing_subnet_ids) > 0 ? null : module.aws_vpc[0].aws_vpc["id"]
    "version"                   = aws_eks_cluster.eks.version
    "kubeconfig"                = local.kubeconfig
    "vpc_config"                = aws_eks_cluster.eks.vpc_config
    "node_group_id"             = aws_eks_node_group.eks.id
    "platform_version"          = aws_eks_cluster.eks.platform_version
    "kubernetes_network_config" = aws_eks_cluster.eks.kubernetes_network_config
    "subnets"                   = length(var.aws_existing_subnet_ids) > 0 ? null : {
     (local.snetA) = {
        "id"     = module.aws_subnets[0].aws_subnets[format("%s-snet-a", var.aws_eks_cluster_name)]["id"]
        "vpc_id" = module.aws_subnets[0].aws_subnets[format("%s-snet-a", var.aws_eks_cluster_name)]["vpc_id"]
      }
     (local.snetB) = {
        "id"     = module.aws_subnets[0].aws_subnets[format("%s-snet-b", var.aws_eks_cluster_name)]["id"]
        "vpc_id" = module.aws_subnets[0].aws_subnets[format("%s-snet-b", var.aws_eks_cluster_name)]["vpc_id"]
      }
    }
    subnet_ids = length(var.aws_existing_subnet_ids) > 0 ? var.aws_existing_subnet_ids : [for s in module.aws_subnets[0].aws_subnets : s["id"]]
  }
}