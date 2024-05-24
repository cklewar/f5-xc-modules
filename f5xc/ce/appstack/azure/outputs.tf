output "appstack" {
  value = {
    vnet           = module.network_common.common["vnet"]
    appstack       = module.cluster.appstack
    resource_group = local.f5xc_azure_resource_group
    nodes = {
      master = {
        for node in keys(var.f5xc_cluster_nodes.master) : node => {
          node = module.node_master[node].ce
          config = {
            vpm                = module.config_master_node[node].ce["vpm"]
            user_data          = module.config_master_node[node].ce["user_data"]
            hosts_context_node = module.config_master_node[node].ce["hosts_context_node"]
          }
          network = {
            node   = module.network_master_node[node].ce
            common = module.network_common.common
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
  }
}