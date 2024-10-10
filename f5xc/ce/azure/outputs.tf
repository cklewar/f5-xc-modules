output "ce" {
  value = {
    vnet             = module.network_common.common["vnet"]
    resource_group   = local.f5xc_azure_resource_group
    secure_mesh_site = var.f5xc_secure_mesh_site_version == 1 ? module.secure_mesh_site.0.secure_mesh_site : module.secure_mesh_site_v2.0.secure_mesh_site
    nodes            = {
      for node in keys(var.f5xc_cluster_nodes) : node => {
        node    = module.node[node].ce
        config  = module.config[node].ce
        secure  = var.f5xc_is_secure_cloud_ce ? module.secure_ce[node].ce : null
        private = var.f5xc_is_private_cloud_ce ? module.private_ce[node].ce : null
        network = {
          node   = module.network_node[node].ce
          common = module.network_common.common
        }
      }
    }
  }
}