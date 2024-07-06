output "ce" {
  value = {
    nodes                                = module.node.ce
    network                              = module.network_common
    firewall                             = local.create_network ? module.firewall.ce : null
    secure_mesh                          = module.secure_mesh_site
    google_compute_region_instance_group = module.node.google_compute_region_instance_group
  }
}