output "appstack" {
  value = {
    network = {
      common = module.network_common.common
    }
    site       = module.cluster.appstack.voltstack
    cluster    = module.cluster.appstack.cluster
    kubeconfig = module.cluster.appstack.kubeconfig
    ce = {
      master = {
        nodes = module.node_master.ce
        config = {
          vpm                = module.config_master_node.ce["vpm"]
          user_data          = module.config_master_node.ce["user_data"]
          hosts_context_node = module.config_master_node.ce["hosts_context_node"]
        }
      }
      worker = length(keys(var.f5xc_cluster_nodes.worker)) > 0 ? {
        nodes = module.node_worker.0.ce
        config = {
          vpm                = module.config_worker_node.ce["vpm"]
          user_data          = module.config_worker_node.ce["user_data"]
          hosts_context_node = module.config_worker_node.ce["hosts_context_node"]
        }
      } : {}
    }
  }
}