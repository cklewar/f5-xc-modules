output "ce" {
  value = {
    slo_subnetwork = google_compute_subnetwork.slo_subnet
    sli_subnetwork = var.is_multi_nic ? google_compute_subnetwork.sli_subnet[0] : null
  }
}