data "google_compute_instance" "node0" {
  depends_on = [module.site_wait_for_online]
  name       = local.f5xc_instance_names[0]
  zone       = element(var.f5xc_gcp_zone_names, 0)
}

data "google_compute_instance" "node1" {
  depends_on = [module.site_wait_for_online]
  count      = var.f5xc_gcp_node_number > 1 ? 1 : 0
  name       = local.f5xc_instance_names[1]
  zone       = element(var.f5xc_gcp_zone_names, 2)
}

data "google_compute_instance" "node2" {
  depends_on = [module.site_wait_for_online]
  count      = var.f5xc_gcp_node_number > 1 ? var.f5xc_gcp_node_number : 0
  name       = local.f5xc_instance_names[2]
  zone       = element(var.f5xc_gcp_zone_names, 1)
}