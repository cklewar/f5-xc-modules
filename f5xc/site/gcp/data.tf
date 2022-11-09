data "google_compute_instance" "instance" {
  name = var.f5xc_gcp_site_name
  zone = element(var.f5xc_gcp_zone_names, 0)
}