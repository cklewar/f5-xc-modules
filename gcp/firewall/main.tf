resource "google_compute_firewall" "allow-ssh" {
  name    = var.gcp_compute_firewall_name
  network = var.gcp_compute_firewall_compute_network

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  //target_tags = ["ssh"]
}