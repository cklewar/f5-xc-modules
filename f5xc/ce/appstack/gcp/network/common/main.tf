resource "google_compute_network" "slo" {
  count                   = var.create_network ? 1 : 0
  name                    = "${var.f5xc_cluster_name}-slo-vpc-network"
  auto_create_subnetworks = var.gcp_auto_create_subnetworks
}

resource "google_compute_subnetwork" "slo" {
  count         = var.create_subnetwork ? 1 : 0
  name          = var.gcp_subnet_name_slo
  region        = var.gcp_region
  network       = var.create_network ? google_compute_network.slo.0.id : data.google_compute_network.slo.0.name
  ip_cidr_range = var.gcp_subnet_ip_cidr_range_slo
}