output "compute_firewall" {
  value = {
    "id"                 = google_compute_firewall.firewall.id
    "name"               = google_compute_firewall.firewall.name
    "network"            = google_compute_firewall.firewall.network
    "source_ranges"      = google_compute_firewall.firewall.source_ranges
    "destination_ranges" = google_compute_firewall.firewall.destination_ranges
  }
}