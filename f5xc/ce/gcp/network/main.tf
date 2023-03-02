resource "google_compute_network" "slo_vpc_network" {
  name                    = "${var.network_name}-slo-vpc-network"
  auto_create_subnetworks = var.auto_create_subnetworks
}

resource "google_compute_network" "sli_vpc_network" {
  count                   = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? 1 : 0
  name                    = "${var.network_name}-sli-vpc-network"
  auto_create_subnetworks = var.auto_create_subnetworks
}

resource "google_compute_subnetwork" "slo_subnet" {
  name          = "${var.network_name}-slo-subnetwork"
  ip_cidr_range = var.fabric_subnet_outside
  region        = var.gcp_region
  network       = google_compute_network.slo_vpc_network.id
}

resource "google_compute_subnetwork" "sli_subnet" {
  count         = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? 1 : 0
  name          = "${var.network_name}-sli-subnetwork"
  ip_cidr_range = var.fabric_subnet_inside
  region        = var.gcp_region
  network       = google_compute_network.sli_vpc_network[0].id
}

resource "google_compute_firewall" "slo" {
  for_each           = var.f5xc_ce_slo_firewall.rules
  name               = each.value.name
  network            = google_compute_network.slo_vpc_network.name
  direction          = each.value.direction
  target_tags        = each.value.target_tags
  source_ranges      = each.value.direction == "INGRESS" ? each.value.ranges : null
  destination_ranges = each.value.direction == "EGRESS" ? each.value.ranges : null

  dynamic "allow" {
    for_each = each.value.allow
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }
  dynamic "deny" {
    for_each = each.value.deny
    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }
  log_config {
    metadata = each.value.log_config
  }
}

resource "google_compute_firewall" "sli" {
  for_each           = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? var.f5xc_ce_sli_firewall.rules : []
  name               = each.value.name
  network            = google_compute_network.slo_vpc_network.name
  direction          = each.value.direction
  target_tags        = each.value.target_tags
  source_ranges      = each.value.direction == "INGRESS" ? each.value.ranges : null
  destination_ranges = each.value.direction == "EGRESS" ? each.value.ranges : null

  dynamic "allow" {
    for_each = each.value.allow
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }
  dynamic "deny" {
    for_each = each.value.deny
    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }
  log_config {
    metadata = each.value.log_config
  }
}