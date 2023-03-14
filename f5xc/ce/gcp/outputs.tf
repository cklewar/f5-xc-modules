output "ce" {
  value = {
    master-0 = {
      node     = module.node[0].ce["master-0"]
      config   = module.config[0].ce["master-0"]
      network  = local.create_network ? module.network[0].ce["master-0"] : null
      firewall = module.firewall.ce["master-0"]
    }
  }
}
