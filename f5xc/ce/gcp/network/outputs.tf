output "network" {
  value = {
    slo_subnetwork = google_compute_subnetwork.slo_subnet.name
    slo_network    = google_compute_network.slo_vpc_network.name
    sli_subnetwork = google_compute_subnetwork.sli_subnet.name
    sli_network    = google_compute_network.sli_vpc_network.name
  }
}