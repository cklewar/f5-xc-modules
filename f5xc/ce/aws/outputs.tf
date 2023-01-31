output "nodes" {
  value = {
    master-0 = {
      node    = module.node["node0"].ce
      config  = module.config["node0"].ce
      network = {
        common     = module.network.common
        interfaces = module.network.nodes["node0"]
      }
    }
    master-1 = length(var.f5xc_aws_vpc_az_nodes) > 1 ? {
      node    = module.node["node1"].ce
      config  = module.config["node1"].ce
      network = {
        common     = module.network.common
        interfaces = module.network.nodes["node1"]
      }
    } : null
    master-2 = length(var.f5xc_aws_vpc_az_nodes) > 1 ? {
      node    = module.node["node2"].ce
      config  = module.config["node2"].ce
      network = {
        common     = module.network.common
        interfaces = module.network.nodes["node2"]
      }
    } : null
  }
}