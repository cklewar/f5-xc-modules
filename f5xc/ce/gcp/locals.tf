locals {
  cluster_labels              = var.f5xc_fleet_label != "" ? { "ves.io/fleet" = var.f5xc_fleet_label } : {}
  create_network              = var.subnet_outside_name != "" || (var.subnet_inside_name != "" && var.subnet_outside_name != "") ? true : false
  f5xc_secure_ce_slo_firewall = {
    rules = [
      {
        name        = "${var.project_name}-slo-allow-http-nat-t-ingress-${var.gcp_region}"
        priority    = 1000
        description = "Allow SLO HTTPS and NAT-T"
        direction   = "INGRESS"
        target_tags = []
        ranges      = var.f5xc_ip_ranges_americas
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
        name        = "${var.project_name}-slo-allow-ssh-iap-ingress-${var.gcp_region}"
        priority    = 65534
        description = "Allow SLO SSH and IAP"
        direction   = "INGRESS"
        ranges      = var.f5xc_ip_ranges_americas
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
      },
       {
        name        = "${var.project_name}-sli-deny-all-egress-${var.gcp_region}"
        priority    = 65535
        description = "deny all SLO"
        direction   = "EGRESS"
        ranges      = ["0.0.0.0/0"]
        target_tags = []
        allow       = []
        deny        = [
          {
            protocol = "all"
            ports = []
          }
        ]
        log_config = {
          metadata = "INCLUDE_ALL_METADATA"
        }
      }
    ]
  }

  f5xc_secure_ce_sli_firewall = {
    rules = [
      {
        name        = "${var.project_name}-sli-allow-ssh-egress-${var.gcp_region}"
        priority    = 65534
        description = "Allow SLI SSH"
        direction   = "EGRESS"
        ranges      = concat(var.f5xc_ce_egress_ip_ranges, var.f5xc_ip_ranges_americas)
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
        name        = "${var.project_name}-sli-allow-ssh-ingress-${var.gcp_region}"
        priority    = 65534
        description = "Allow SLI SSH"
        direction   = "INGRESS"
        ranges      = var.f5xc_ip_ranges_americas
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
        name        = "${var.project_name}-sli-deny-all-egress-${var.gcp_region}"
        priority    = 65535
        description = "deny all SLI"
        direction   = "EGRESS"
        ranges      = ["0.0.0.0/0"]
        target_tags = []
        allow       = []
        deny        = [
          {
            protocol = "all"
            ports = []
          }
        ]
        log_config = {
          metadata = "INCLUDE_ALL_METADATA"
        }
      }
    ]
  }
}