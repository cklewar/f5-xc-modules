output "nodes" {
  value = {
    master-0 = {
      node    = module.node.ce
      config  = module.config.ce
      network = module.network.ce
    }
  }
}