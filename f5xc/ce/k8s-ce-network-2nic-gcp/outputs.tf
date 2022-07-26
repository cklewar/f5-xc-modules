output "slo_subnetwork" {
  value = google_compute_subnetwork.slo_subnet.name
}

output "slo_network" {
  value = google_compute_network.slo_vpc_network.name
}

output "sli_subnetwork" {
  value = google_compute_subnetwork.sli_subnet.name
}

output "sli_network" {
  value = google_compute_network.sli_vpc_network.name
}