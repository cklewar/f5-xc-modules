output "nodes" {
  value = {
    nodes = {
      for node in keys(var.f5xc_kvm_site_nodes) : node => {
        node = module.node[node].ce
      }
    }
    secure_mesh_site = module.secure_mesh_site
  }
}
