locals {
  cluster_labels       = var.f5xc_fleet_label != "" ? { "ves.io/fleet" = var.f5xc_fleet_label } : {}
  create_network       = var.fabric_subnet_outside != "" || (var.fabric_subnet_inside != "" && var.fabric_subnet_outside != "") ? true : false
  f5xc_ce_slo_firewall = {
    rules = [
      {
        name        = "${var.instance_name}-slo-allow-ingress-${var.gcp_region}"
        priority    = 1000
        description = "Allow SLO HTTPS and NAT-T"
        direction   = "INGRESS"
        target_tags = []
        ranges      = [var.f5xc_ip_ranges_americas]
        allow       = [
          {
            protocol = "tcp"
            ports    = ["443"]
          },
          {
            protocol = "udp"
            ports    = ["4500"]
          }
        ]
        deny       = []
        log_config = {
          metadata = "INCLUDE_ALL_METADATA"
        }
      },
      {
        name        = "${var.network_name}-slo-allow-ingress-${var.gcp_region}"
        priority    = 65534
        description = "Allow SLO SSH and IAP"
        direction   = "INGRESS"
        ranges      = [var.f5xc_ip_ranges_americas]
        target_tags = []
        allow       = [
          {
            protocol = "tcp"
            ports    = ["22", "3389"]
          }
        ]
        deny       = []
        log_config = {
          metadata = "INCLUDE_ALL_METADATA"
        }
      }
    ]
  }
  f5xc_ce_sli_firewall = {
    rules = [
      {
        name        = "${var.network_name}-sli-allow-egress-${var.gcp_region}"
        priority    = 65534
        description = "Allow SLI SSH"
        direction   = "EGRESS"
        ranges      = [var.f5xc_ce_egress_ip_ranges, var.f5xc_ip_ranges_americas]
        target_tags = []
        allow       = [
          {
            protocol = "tcp"
            ports    = ["22"]
          }
        ]
        deny       = []
        log_config = {
          metadata = "INCLUDE_ALL_METADATA"
        }
      },
      {
        name        = "${var.network_name}-sli-allow-ingress-${var.gcp_region}"
        priority    = 65534
        description = "Allow SLI SSH"
        direction   = "INGRESS"
        ranges      = [var.f5xc_ip_ranges_americas]
        target_tags = []
        allow       = [
          {
            protocol = "tcp"
            ports    = ["22"]
          }
        ]
        deny       = []
        log_config = {
          metadata = "INCLUDE_ALL_METADATA"
        }
      },
      {
        name        = "${var.network_name}-sli-deny-egress-${var.gcp_region}"
        priority    = 65535
        description = "deny all SLI"
        direction   = "EGRESS"
        ranges      = ["0.0.0.0/0"]
        target_tags = []
        allow       = []
        deny        = [
          {
            protocol = "all"
          }
        ]
        log_config = {
          metadata = "INCLUDE_ALL_METADATA"
        }
      }
    ]
  }
}