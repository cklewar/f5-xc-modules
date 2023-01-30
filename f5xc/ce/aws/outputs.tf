output "ce" {
  value = {
    master-0 = {
      # node    = module.node[node0].ce
      config  = module.config[node0].ce
      # network = local.create_network ? module.network[node0].ce : null
    }
  }
}