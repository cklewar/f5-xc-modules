output "common" {
  value = {
    slo_network    = var.create_network ? google_compute_network.slo.0 : data.google_compute_network.slo.0
    sli_network    = var.create_network && var.is_multi_nic ? google_compute_network.sli.0 : var.create_network == false && var.is_multi_nic ? data.google_compute_network.sli.0 : null
    slo_subnetwork = var.create_subnetwork ? google_compute_subnetwork.slo.0 : data.google_compute_subnetwork.slo.0
    sli_subnetwork = var.create_subnetwork && var.is_multi_nic ? google_compute_subnetwork.sli.0 : var.is_multi_nic ? data.google_compute_subnetwork.sli.0 : null
    nat            = ""
  }
}