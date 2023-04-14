output "nodes" {
  value = {
    vnet           = module.network_common.common["existing_vnet"] == null ? module.network_common.common["vnet"] : null
    existing_vnet  = module.network_common.common["existing_vnet"] != null ? module.network_common.common["existing_vnet"] : null
    resource_group = local.f5xc_azure_resource_group
    master-0       = {
      node    = module.node["node0"].ce
      config  = module.config["node0"].ce
      network = {
        node   = module.network_node["node0"].ce
        common = module.network_common.common
      }
    }
    master-1 = length(var.f5xc_azure_az_nodes) == 3 ? {
      node    = module.node["node1"].ce
      config  = module.config["node1"].ce
      network = {
        node   = module.network_node["node1"].ce
        common = module.network_common.common
      }
    } : null
    master-2 = length(var.f5xc_azure_az_nodes) == 3 ? {
      node    = module.node["node2"].ce
      config  = module.config["node2"].ce
      network = {
        node   = module.network_node["node2"].ce
        common = module.network_common.common
      }
    } : null
  }
}