output "network" {
  value = {
    "id"   = google_compute_network.network.id
    "name" = google_compute_network.network.name
  }
}