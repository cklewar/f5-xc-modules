output "ce" {
  value = {
    network = {
      common = local.create_network ? module.network_common[0].common : null
    }
    firewall = local.create_network ? module.firewall[0].ce : null
    nodes    = {
      for node in keys(var.f5xc_ce_nodes) : node=> {
        node    = module.node[node].ce
        config  = module.config[node].ce
        network = {
          node = module.network_node[node].ce
        }
      }
    }
  }
}