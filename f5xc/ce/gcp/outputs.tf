output "ce" {
  value = {
    master-0 = {
      node    = module.node.ce["master-0"]
      config  = module.config.ce["master-0"]
      network = module.network[0].ce["master-0"]
    }
  }
}