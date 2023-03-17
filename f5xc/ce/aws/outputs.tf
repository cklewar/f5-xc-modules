output "nodes" {
  value = {
    iam = {
      role             = aws_iam_role.role
      policy           = aws_iam_policy.policy
      attachment       = aws_iam_role_policy_attachment.attachment
      instance_profile = aws_iam_instance_profile.instance_profile
    }
    nlb = length(var.f5xc_aws_vpc_az_nodes) == 3 ? {
      nlb = module.network_nlb[0].nlb
    } : null
    master-0 = {
      node    = module.node["node0"].ce
      config  = module.config["node0"].ce
      network = {
        common = module.network_common.common
        node   = module.network_node["node0"].ce
      }
      secure_ce = var.f5xc_is_secure_cloud_ce ? module.secure_ce["node0"].ce : null
    }
    master-1 = length(var.f5xc_aws_vpc_az_nodes) == 3 ? {
      node    = module.node["node1"].ce
      config  = module.config["node1"].ce
      network = {
        common = module.network_common.common
        node   = module.network_node["node1"].ce
      }
      secure_ce = var.f5xc_is_secure_cloud_ce ? module.secure_ce["node1"].ce : null
    } : null
    master-2 = length(var.f5xc_aws_vpc_az_nodes) == 3 ? {
      node    = module.node["node2"].ce
      config  = module.config["node2"].ce
      network = {
        common = module.network_common.common
        node   = module.network_node["node2"].ce
      }
      secure_ce = var.f5xc_is_secure_cloud_ce ? module.secure_ce["node2"].ce : null
    } : null
  }
}