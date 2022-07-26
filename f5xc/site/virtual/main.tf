resource "volterra_virtual_site" "virtual-site" {
  name      = "ck-virtual-site-ams"
  namespace = var.f5xc_namespace

  site_selector {
    expressions = ["ves.io/siteName in (ves-io-ams9-ams)"]
  }

  site_type = "REGIONAL_EDGE"
}