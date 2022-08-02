resource "volterra_site_mesh_group" "site_mesh_group" {
  name        = var.f5xc_site_mesh_group_name
  namespace   = var.f5xc_namespace
  tunnel_type = [var.f5xc_tunnel_type]
  type        = [var.f5xc_site_2_site_connection_type]
  description = var.f5xc_site_mesh_group_description

  dynamic "hub" {
    for_each = var.f5xc_site_2_site_connection_type != var.f5xc_site_2_site_connection_type_hub && var.f5xc_site_site_hub_name != "" ? 1 : 0
    content {
      name      = var.f5xc_site_site_hub_name
      namespace = var.f5xc_namespace
      tenant    = var.f5xc_tenant
    }
  }

  dynamic "virtual_site" {
    for_each = var.f5xc_virtual_site_name != "" ? 1 : 0
    content {
      name      = var.f5xc_virtual_site_name
      namespace = var.f5xc_namespace
      tenant    = var.f5xc_tenant
    }
  }
}