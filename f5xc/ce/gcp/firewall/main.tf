resource "google_compute_firewall" "slo" {
  for_each           = {for rule in var.f5xc_ce_slo_firewall.rules :  rule.name => rule}
  name               = each.value.name
  network            = var.slo_network
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
    metadata = each.value.log_config.metadata
  }
}

resource "google_compute_firewall" "sli" {
  for_each           = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? {for rule in var.f5xc_ce_sli_firewall.rules :  rule.name => rule} : {}
  name               = each.value.name
  network            = var.sli_network
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
    metadata = each.value.log_config.metadata
  }
}