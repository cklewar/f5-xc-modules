resource "volterra_virtual_site" "virtual-site" {
  name      = var.f5xc_virtual_site_name
  namespace = var.f5xc_namespace

  site_selector {
    expressions = var.f5xc_virtual_site_selector_expression
  }

  site_type = var.f5xc_virtual_site_type
}