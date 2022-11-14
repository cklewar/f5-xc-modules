/*data "external" "instance" {
  depends_on = [module.site_wait_for_online]
  program = ["./scripts/script.sh"]
}*/

data "google_compute_instance" "instance" {
  depends_on = [module.site_wait_for_online]
  # name = var.f5xc_gcp_site_name
  # name = volterra_gcp_vpc_site.site.name
  # name = "f5xc-lab-gcp-01a-t8q5"
  # regex(local.pattern, module.site.gcp_vpc["params"])
  name = regex(local.f5xc_gcp_instance_name_pattern, volterra_tf_params_action.gcp_vpc_action.tf_output)[0]
  # zone = element(var.f5xc_gcp_zone_names, 0)
  zone       = "europe-west6-a"
  name = data.external.instance.result.instance_name
  zone = element(var.f5xc_gcp_zone_names, 0)
}