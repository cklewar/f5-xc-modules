output "ce" {
  value = {
    nodes    = module.node.ce
    network  = local.create_network ? module.network_common[0].common : null
    firewall = local.create_network ? module.firewall[0].ce : null
  }
}