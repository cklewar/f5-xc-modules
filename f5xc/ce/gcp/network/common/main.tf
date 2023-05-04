resource "google_compute_network" "slo_vpc_network" {
  name                    = "${var.f5xc_cluster_name}-slo-vpc-network"
  auto_create_subnetworks = var.auto_create_subnetworks
}

resource "google_compute_network" "sli_vpc_network" {
  count                           = var.is_multi_nic ? 1 : 0
  name                            = "${var.f5xc_cluster_name}-sli-vpc-network"
  auto_create_subnetworks         = var.auto_create_subnetworks
  delete_default_routes_on_create = var.f5xc_is_secure_cloud_ce ? true : false
}

/*resource "google_compute_network_peering" "peering1" {
  for_each     = ""
  name         = "peering1"
  network      = google_compute_network.default.self_link
  peer_network = google_compute_network.other.self_link
}*/