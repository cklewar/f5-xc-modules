resource "google_compute_network" "slo_vpc_network" {
  name                    = "${var.project_name}-slo-vpc-network"
  auto_create_subnetworks = var.auto_create_subnetworks
}

resource "google_compute_network" "sli_vpc_network" {
  count                           = var.is_multi_nic ? 1 : 0
  name                            = "${var.project_name}-sli-vpc-network"
  auto_create_subnetworks         = var.auto_create_subnetworks
  delete_default_routes_on_create = var.f5xc_is_secure_cloud_ce ? true : false
}