output "ce" {
  value = {
    vpc = module.network_common.common["vpc"]
    iam = {
      role             = var.aws_existing_iam_profile_name != null ? data.aws_iam_role.existing_iam_role.0 : aws_iam_role.role.0
      policy           = var.aws_existing_iam_profile_name != null ? null : aws_iam_policy.policy.0
      attachment       = var.aws_existing_iam_profile_name != null ? null : aws_iam_role_policy_attachment.attachment.0
      instance_profile = var.aws_existing_iam_profile_name != null ? data.aws_iam_instance_profile.existing_iam_profile.0 : aws_iam_instance_profile.instance_profile.0
    }
    ssh_key = var.ssh_public_key != null ? aws_key_pair.aws_key.0 : data.aws_key_pair.existing_aws_key.0
    nlb     = length(var.f5xc_aws_vpc_az_nodes) == 3 ? {
      nlb = module.network_nlb.0.nlb
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
    secure_mesh_site = module.secure_mesh_site
  }
}