data "volterra_namespace" "shared" {
  name = "shared"
}

module "virtual_site" {
  source                                = "../site/virtual"
  count                                 = var.f5xc_create_virtual_site && var.f5xc_virtual_site_name != "" ? 1 : 0
  f5xc_virtual_site_name                = var.f5xc_virtual_site_name
  f5xc_virtual_site_type                = var.f5xc_virtual_site_type
  f5xc_virtual_site_description         = var.f5xc_virtual_site_description
  f5xc_virtual_site_selector_expression = var.f5xc_virtual_site_selector_expression
}

resource "volterra_site_mesh_group" "site_mesh_group" {
  name        = var.f5xc_site_mesh_group_name
  namespace   = var.f5xc_namespace
  description = var.f5xc_site_mesh_group_description

  dynamic "hub_mesh" {
    for_each = var.f5xc_site_2_site_connection_type == var.f5xc_site_2_site_connection_type_hub_mesh ? [1] : []
    content {
      control_and_data_plane_mesh = var.f5xc_site_mesh_group_hub_mesh_control_and_data_plane_mesh
      data_plane_mesh             = var.f5xc_site_mesh_group_hub_mesh_data_plane_mesh
    }
  }

  dynamic "full_mesh" {
    for_each = var.f5xc_site_2_site_connection_type == var.f5xc_site_2_site_connection_type_full_mesh ? [1] : []
    content {
      data_plane_mesh             = var.f5xc_data_plane_mesh
      control_and_data_plane_mesh = !var.f5xc_data_plane_mesh ? true : false
    }
  }

  dynamic "spoke_mesh" {
    for_each = var.f5xc_site_2_site_connection_type == var.f5xc_site_2_site_connection_type_spoke_mesh ? [1] : []
    content {
      hub_mesh_group {
        name      = var.f5xc_site_site_hub_name
        tenant    = data.volterra_namespace.shared.tenant_name
        namespace = data.volterra_namespace.shared.name
      }
    }
  }

  dynamic "virtual_site" {
    for_each = var.f5xc_virtual_site_name != "" ? [1] : []
    content {
      name      = var.f5xc_create_virtual_site ? module.virtual_site[0].virtual_site["name"] : var.f5xc_virtual_site_name
      tenant    = data.volterra_namespace.shared.tenant_name
      namespace = data.volterra_namespace.shared.name
    }
  }
}