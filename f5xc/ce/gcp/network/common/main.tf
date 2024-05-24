resource "google_compute_network" "slo" {
  count                   = var.create_network ? 1 : 0
  name                    = "${var.f5xc_cluster_name}-slo-vpc-network"
  auto_create_subnetworks = var.gcp_auto_create_subnetworks
}

resource "google_compute_network" "sli" {
  count                           = var.create_network && var.is_multi_nic ? 1 : 0
  name                            = "${var.f5xc_cluster_name}-sli-vpc-network"
  auto_create_subnetworks         = var.gcp_auto_create_subnetworks
  delete_default_routes_on_create = var.f5xc_is_secure_cloud_ce ? true : false
}

resource "google_compute_subnetwork" "slo" {
  count         = var.create_subnetwork ? 1 : 0
  name          = var.gcp_subnet_name_slo
  region        = var.gcp_region
  network       = var.create_network ? google_compute_network.slo.0.id : data.google_compute_network.slo.0.name
  ip_cidr_range = var.gcp_subnet_ip_cidr_range_slo
}

resource "google_compute_subnetwork" "sli" {
  count         = var.create_subnetwork && var.is_multi_nic ? 1 : 0
  name          = var.gcp_subnet_name_sli
  region        = var.gcp_region
  network       = var.create_network ? google_compute_network.sli.0.id : data.google_compute_network.sli.0.name
  ip_cidr_range = var.gcp_subnet_ip_cidr_range_sli
}

/*resource "google_compute_network_peering" "peering1" {
  for_each     = ""
  name         = "peering1"
  network      = google_compute_network.default.self_link
  peer_network = google_compute_network.other.self_link
}*/