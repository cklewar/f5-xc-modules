resource "google_compute_network" "vpc_network" {
  mtu                             = var.gcp_compute_network_mtu
  name                            = var.gcp_compute_network_name
  project                         = var.gcp_project_name
  routing_mode                    = var.gcp_compute_network_routing_mode
  auto_create_subnetworks         = var.gcp_compute_network_auto_create_subnetworks
  delete_default_routes_on_create = var.gcp_compute_network_delete_default_routes_on_create
}