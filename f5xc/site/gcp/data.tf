data "external" "instance" {
  depends_on = [module.site_wait_for_online]
  program = ["./scripts/script.sh"]
}

data "google_compute_instance" "instance" {
  depends_on = [module.site_wait_for_online]
  name = data.external.instance.result.instance_name
  zone = element(var.f5xc_gcp_zone_names, 0)
}