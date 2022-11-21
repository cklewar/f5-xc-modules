output "aws_eks" {
  value = {
    "id"                        = module.aws_eks.aws_eks["id"]
    "name"                      = module.aws_eks.aws_eks["name"]
    "tags"                      = module.aws_eks.aws_eks["tags"]
    "vpc_id"                    = module.aws_eks.aws_eks["vpc_id"]
    "version"                   = module.aws_eks.aws_eks["version"]
    "kubeconfig"                = module.k8s.kubeconfig
    "vpc_config"                = module.aws_eks.aws_eks["vpc_config"]
    "node_group_id"             = aws_eks_node_group["id"]
    "platform_version"          = module.aws_eks.aws_eks["platform_version"]
    "kubernetes_network_config" = module.aws_eks.aws_eks["kubernetes_network_config"]
  }
}