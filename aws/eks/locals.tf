locals {
  route_table_id                         = var.aws_route_table_id != "" ? var.aws_route_table_id : data.aws_vpc.eks_vpc_data.main_route_table_id
  aws_eks_node_iam_role_name             = format("%s-node-iam-role", var.aws_eks_cluster_name)
  aws_eks_cluster_security_group_name    = format("%s-cluster-sg", var.aws_eks_cluster_name)
  aws_eks_node_security_group_name       = format("%s-eks-node-sg", var.aws_eks_cluster_name)
  aws_eks_cluster_iam_role_name          = format("%s-cluster-iam-role", var.aws_eks_cluster_name)
  aws_eks_node_iam_instance_profile_name = format("%s-iam-instance-profile", var.aws_eks_cluster_name)

  # fix taken as per suggestion from https://github.com/hashicorp/terraform/issues/19558#issuecomment-450840955
  empty_map = {
    data = base64encode("")
  }
  empty_list_map = [local.empty_map]
  tmp_list       = coalescelist(aws_eks_cluster.eks.*.certificate_authority, [local.empty_list_map])
  tmp_list_map   = local.tmp_list[0]
  base64_ca_data = lookup(local.tmp_list_map[0], "data", "")
  ca_data        = base64decode(local.base64_ca_data)

  node_userdata = templatefile(format("%s/templates/eks_node_userdata.yml", path.module), {
    endpoint         = aws_eks_cluster.eks.endpoint
    certificate_data = local.base64_ca_data
    cluster_name     = var.aws_eks_cluster_name
  })

  config_map_aws_auth = templatefile(format("%s/templates/config_map_aws_auth.yml", path.module), {
    role_arn = join("", aws_iam_role.eks_node.*.arn)
  })

  kubeconfig = templatefile(format("%s/templates/kubeconfig.yml", path.module), {
    endpoint         = aws_eks_cluster.eks.endpoint
    certificate_data = local.base64_ca_data
    cluster_name     = var.aws_eks_cluster_name
    aws_access_key   = var.aws_access_key
    aws_secret_key   = var.aws_secret_key
  })
}