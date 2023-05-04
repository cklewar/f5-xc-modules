output "ce" {
  value = {
    for node in keys(var.f5xc_ce_nodes) : node=> {
      node    = module.node[node].ce
      config  = module.config[node].ce
      network = {
        node   = module.network_node[node].ce
        common = module.network_common[0].common
      }
      firewall = module.firewall[node].ce
    }
  }
}