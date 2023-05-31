output "vpc_network" {
  value = {
    "id"           = google_compute_network.vpc_network.id
    "name"         = google_compute_network.vpc_network.name
    "self_link"    = google_compute_network.vpc_network.self_link
    "gateway_ipv4" = google_compute_network.vpc_network.gateway_ipv4
  }
}