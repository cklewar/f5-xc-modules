output "ce" {
  value = {
    master-0 = {
      node    = module.node[0].ce["master-0"]
      config  = module.config[0].ce["master-0"]
      network = module.network[0].ce["master-0"]
    }
  }
}