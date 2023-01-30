output "ce" {
  value = {
    master-0 = {
      node    = module.node[0].ce
      config  = module.config[0].ce
      network = local.create_network ? module.network[0].ce : null
    }
  }
}