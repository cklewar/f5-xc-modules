output "ce" {
  value = {
    master = {
      node    = module.node.ce
      config  = module.config.ce
      network = module.network.ce
    }
  }
}