data "google_compute_instance" "instance" {
  depends_on = [module.site_wait_for_online]
  name = var.f5xc_gcp_site_name
  zone = element(var.f5xc_gcp_zone_names, 0)
}