resource "google_compute_subnetwork" "subnetwork" {
  name          = var.gcp_compute_subnetwork_name
  ip_cidr_range = var.gcp_compute_subnetwork_ip_cidr_range
  region        = var.gcp_region
  network       = var.gcp_compute_network_id

  dynamic "secondary_ip_range" {
    for_each = var.gcp_compute_subnetwork_secondary_ip_range_range_name != "" && var.gcp_compute_subnetwork_secondary_ip_range_ip_cidr_range != "" ? [1] : []
    content {
      range_name    = var.gcp_compute_subnetwork_secondary_ip_range_range_name
      ip_cidr_range = var.gcp_compute_subnetwork_secondary_ip_range_ip_cidr_range
    }
  }
}