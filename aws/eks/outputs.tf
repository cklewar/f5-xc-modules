output "aws_eks" {
  value = {
    vpc_id                                            = var.aws_vpc_id
    userdata                                          = local.node_userdata
    kubeconfig                                        = local.kubeconfig
    instance_ips                                      = data.aws_vpc.eks_vpc_data.main_route_table_id
    aws_eks_cluster_id                                = aws_eks_cluster.eks.id
    config_map_aws_auth                               = local.config_map_aws_auth
    eks_cluster_endpoint                              = aws_eks_cluster.eks.endpoint
    eks_cluster_kubeconfig_certificate_authority_data = aws_eks_cluster.eks.certificate_authority[0].data
  }
}