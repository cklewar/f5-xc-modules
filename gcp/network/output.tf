output "vpc_network" {
  value = {
    "id"           = google_compute_network.vpc_network.id
    "name"         = google_compute_network.vpc_network.name
    "gateway_ipv4" = google_compute_network.vpc_network.gateway_ipv4
  }
}