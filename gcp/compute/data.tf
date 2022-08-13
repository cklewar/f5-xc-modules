data "google_compute_subnetwork" "subnetwork_inside" {
  name = var.gcp_compute_instance_inside_subnet_name
}