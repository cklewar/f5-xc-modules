data "google_compute_network" "slo" {
  count = !var.create_network ? 1 : 0
  name  = var.gcp_existing_network_slo
}

data "google_compute_subnetwork" "slo" {
  count = !var.create_subnetwork ? 1 : 0
  name  = var.gcp_existing_subnet_network_slo
}