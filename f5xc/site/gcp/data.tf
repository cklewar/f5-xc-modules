data "google_compute_instance" "instance" {
  depends_on = [module.site_wait_for_online]
  name = regex(local.f5xc_gcp_instance_name_pattern, volterra_tf_params_action.gcp_vpc_action.tf_output)[0]
  zone = element(var.f5xc_gcp_zone_names, 0)
}