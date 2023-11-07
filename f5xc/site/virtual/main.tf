resource "volterra_virtual_site" "virtual_site" {
  name        = var.f5xc_virtual_site_name
  labels      = var.f5xc_virtual_site_labels
  namespace   = var.f5xc_namespace
  site_type   = var.f5xc_virtual_site_type
  description = var.f5xc_virtual_site_description

  site_selector {
    expressions = var.f5xc_virtual_site_selector_expression
  }

  // This is needed so that there is some time to sync namespace between eywa and akar
  provisioner "local-exec" {
    command = "sleep 20s"
  }
}