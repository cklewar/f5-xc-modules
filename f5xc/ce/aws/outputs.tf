output "nodes" {
  value = {
    master-0 = {
      node    = module.node["node0"].ce
      config  = module.config["node0"].ce
      network = {
        common = module.network_common.common
        node   = module.network_node["node0"].ce
      }
    }
    master-1 = length(var.f5xc_aws_vpc_az_nodes) > 1 ? {
      node    = module.node["node1"].ce
      config  = module.config["node1"].ce
      network = {
        common = module.network_common.common
        node   = module.network_node["node1"].ce
      }
    } : null
    master-2 = length(var.f5xc_aws_vpc_az_nodes) > 1 ? {
      node    = module.node["node2"].ce
      config  = module.config["node2"].ce
      network = {
        common = module.network_common.common
        node   = module.network_node["node2"].ce
      }
    } : null
  }
}