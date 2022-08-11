resource "volterra_virtual_network" "virtual_network" {
  name                      = var.f5xc_vn_name
  namespace                 = var.f5xc_namespace
  site_local_network        = var.f5xc_site_local_network
  site_local_inside_network = var.f5xc_site_local_inside_network
  global_network            = var.f5xc_global_network

  dynamic static_routes {
    for_each = length(var.f5xc_ip_prefixes) > 0 ? var.f5xc_ip_prefixes : []
    content {
      ip_prefixes = [static_routes.value]
      interface {
        tenant    = var.f5xc_tenant
        namespace = var.f5xc_namespace
        name      = var.f5xc_ip_prefix_next_hop_interface
      }
      attrs = var.f5xc_static_routes_attrs
    }
  }
}
