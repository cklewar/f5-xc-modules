output "common" {
  value = {
    slo_network    = var.create_network ? google_compute_network.slo.0 : data.google_compute_network.slo.0
    slo_subnetwork = var.create_subnetwork ? google_compute_subnetwork.slo.0 : data.google_compute_subnetwork.slo.0
    nat            = ""
  }
}