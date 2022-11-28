resource "google_compute_firewall" "firewall" {
  name        = var.gcp_compute_firewall_name
  project     = var.gcp_project_name
  network     = var.gcp_compute_firewall_compute_network
  priority    = var.gcp_compute_firewall_priority
  disabled    = var.gcp_compute_firewall_disabled
  direction   = var.gcp_compute_firewall_direction
  target_tags = var.gcp_compute_firewall_target_tags
  description = var.gcp_compute_firewall_description

  dynamic "allow" {
    for_each = var.compute_firewall_allow_rules
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  dynamic "deny" {
    for_each = var.compute_firewall_deny_rules
    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }
  // source and destination mutual exclusive
  source_ranges = var.gcp_compute_firewall_source_ranges
  # destination_ranges = var.gcp_compute_firewall_destination_ranges
}