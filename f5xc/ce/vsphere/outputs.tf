output "nodes" {
  value = {
    master-0 = {
      node = module.node["node0"].ce
    }
    master-1 = length(var.f5xc_vsphere_site_nodes) == 3 ? {
      node = module.node["node1"].ce
    } : null
    master-2 = length(var.f5xc_vsphere_site_nodes) == 3 ? {
      node = module.node["node2"].ce
    } : null
  }
}