resource "volterra_site_mesh_group" "site_mesh_group" {
  name        = var.f5xc_site_mesh_group_name
  namespace   = var.f5xc_namespace
  tunnel_type = var.f5xc_tunnel_type
  type        = var.f5xc_site_2_site_connection_type
  description = var.f5xc_site_mesh_group_description
  hub         = null

  dynamic "hub_mesh" {
    for_each = var.f5xc_site_2_site_connection_type == var.f5xc_site_2_site_connection_type_hub_mesh ? [1] : []
    content {
      #name      = var.f5xc_site_site_hub_name
      #namespace = var.f5xc_namespace
      #tenant    = var.f5xc_tenant
    }
  }

  dynamic "full_mesh" {
    for_each = var.f5xc_site_2_site_connection_type == var.f5xc_site_2_site_connection_type_full_mesh
    content {
      #control_and_data_plane_mesh = var.f5xc_site_mesh_group_full_mesh_control_and_data_plane_mesh
      #data_plane_mesh             = var.f5xc_site_mesh_group_full_mesh_data_plane_mesh
    }
  }

  dynamic "spoke_mesh" {
    for_each = var.f5xc_site_2_site_connection_type == var.f5xc_site_2_site_connection_type_spoke_mesh
    content {
      hub_mesh_group {
        name      = var.f5xc_site_site_hub_name
        namespace = var.f5xc_namespace
        tenant    = var.f5xc_tenant
      }
    }
  }

  dynamic "virtual_site" {
    for_each = var.f5xc_virtual_site_name != "" ? [1] : []
    content {
      name      = var.f5xc_virtual_site_name
      namespace = var.f5xc_namespace
      tenant    = var.f5xc_tenant
    }
  }
}