output "common" {
  value = {
    slo_network    = google_compute_network.slo_vpc_network
    sli_network    = var.is_multi_nic ? google_compute_network.sli_vpc_network[0] : null
    slo_subnetwork = google_compute_subnetwork.slo_subnet
    sli_subnetwork = var.is_multi_nic ? google_compute_subnetwork.sli_subnet[0] : null
  }
}