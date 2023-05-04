output "ce" {
  value = {
    vnet           = module.network_common.common["existing_vnet"] == null ? module.network_common.common["vnet"] : null
    existing_vnet  = module.network_common.common["existing_vnet"] != null ? module.network_common.common["existing_vnet"] : null
    resource_group = local.f5xc_azure_resource_group
    nodes          = {
      for node in keys(var.f5xc_azure_az_nodes) : node=> {
        node    = module.node[node].ce
        config  = module.config[node].ce
        secure  = var.f5xc_is_secure_cloud_ce ? module.secure_ce_node[node].ce : null
        network = {
          node   = module.network_node[node].ce
          common = module.network_common.common
        }
      }
    }
  }
}