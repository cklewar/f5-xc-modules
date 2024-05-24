resource "google_compute_address" "address" {
  count   = 1
  name    = "${var.gcp_network_slo}-${var.gcp_region}-nat-${count.index}"
  region  = var.gcp_region
  project = var.gcp_project_id
}

module "router" {
  source                             = "terraform-google-modules/cloud-nat/google"
  name                               = var.gcp_nat_name
  region                             = var.gcp_region
  router                             = var.gcp_nat_router_name
  version                            = "~> 2.0"
  nat_ips                            = google_compute_address.address.*.self_link
  network                            = var.gcp_network_slo
  project_id                         = var.gcp_project_id
  create_router                      = true
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  # nat_ip_allocate_option             = "MANUAL_ONLY"
}