output "nodes" {
  value = {
    master-0 = {
      # node    = module.node["node0"].ce
      config  = module.config["node0"].ce
      network = module.network.ce
      test123 = module.network.test123
    }
  }
}