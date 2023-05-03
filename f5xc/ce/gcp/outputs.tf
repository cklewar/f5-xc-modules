output "ce" {
  value = {
    for node in keys(var.f5xc_ce_nodes) : node=> {
      node     = module.node[node].ce
      config   = module.config[node].ce
      network  = module.network[node].ce
      firewall = module.firewall[node].ce
    }
  }
}