resource "google_compute_subnetwork" "slo_subnet" {
  name          = var.slo_subnet_name
  region        = var.gcp_region
  network       = var.slo_vpc_network_id
  ip_cidr_range = var.subnet_slo_ip_cidr_range
}

resource "google_compute_subnetwork" "sli_subnet" {
  count         = var.is_multi_nic ? 1 : 0
  name          = var.sli_subnet_name
  region        = var.gcp_region
  network       = var.sli_vpc_network_id
  ip_cidr_range = var.subnet_sli_ip_cidr_range
}