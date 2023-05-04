output "ce" {
  value = {
    vpc_id = var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : null
    iam    = {
      role             = aws_iam_role.role
      policy           = aws_iam_policy.policy
      attachment       = aws_iam_role_policy_attachment.attachment
      instance_profile = aws_iam_instance_profile.instance_profile
    }
    ssh_key = aws_key_pair.aws_key
    nlb     = length(var.f5xc_aws_vpc_az_nodes) == 3 ? {
      nlb = module.network_nlb[0].nlb
    } : null
    nodes = {
      for node in keys(var.f5xc_aws_vpc_az_nodes) : node=> {
        node    = module.node[node].ce
        config  = module.config[node].ce
        network = {
          common = module.network_common.common
          node   = module.network_node[node].ce
        }
        secure_ce = var.f5xc_is_secure_cloud_ce ? module.secure_ce[node].ce : null
      }
    }
  }
}