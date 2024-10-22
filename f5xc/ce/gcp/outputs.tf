output "ce" {
  value = {
    nodes            = module.node.ce
    network          = module.network_common
    firewall         = local.create_network ? module.firewall.ce : null
    secure_mesh_site = var.f5xc_secure_mesh_site_version == 1 ? module.secure_mesh_site.0.secure_mesh_site : module.secure_mesh_site_v2.0.secure_mesh_site
  }
}