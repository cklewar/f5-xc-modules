output "kubeconfig" {
  value = local.kubeconfig
}

output "config_map_aws_auth" {
  value = local.config_map_aws_auth
}

output "userdata" {
  value = local.node_userdata
}

output "vpc_id" {
  value = var.aws_vpc_id
}

output "esk_cluster_id" {
  value = aws_eks_cluster.eks.id
}

output "instance_ips" {
  value = data.aws_vpc.eks_vpc_data.main_route_table_id
}


output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_cluster_kubeconfig_certificate_authority_data" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}