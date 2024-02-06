output "appstack" {
  value = {
    nlb = length(var.f5xc_cluster_nodes) == 3 ? {
      nlb = module.network_nlb[0].nlb["nlb"]
    } : null
    iam = {
      role             = aws_iam_role.role
      policy           = aws_iam_policy.policy
      attachment       = aws_iam_role_policy_attachment.attachment
      instance_profile = aws_iam_instance_profile.instance_profile
    }
    vpc_id   = module.network_common.common["vpc"]["id"]
    ssh_key  = aws_key_pair.aws_key
    appstack = module.cluster.appstack
    nodes    = {
      master = {
        for node in keys(var.f5xc_cluster_nodes.master) : node => {
          node   = module.node_master[node].ce
          config = {
            vpm                = module.config_master_node[node].ce["vpm"]
            user_data          = module.config_master_node[node].ce["user_data"]
            hosts_context_node = module.config_master_node[node].ce["hosts_context_node"]
          }
          network = {
            common = module.network_common.common
            node   = module.network_master_node[node].ce
          }
        }
      }
      worker = {
        for node in keys(var.f5xc_cluster_nodes.worker) : node => {
          config = {
            vpm                = module.config_worker_node[node].ce["vpm"]
            user_data          = module.config_worker_node[node].ce["user_data"]
            hosts_context_node = module.config_worker_node[node].ce["hosts_context_node"]
          }
        }
      }
    }
    # secure_mesh_site = module.secure_mesh_site.0.secure_mesh_site
  }
}