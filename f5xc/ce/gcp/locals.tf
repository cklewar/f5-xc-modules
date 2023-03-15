locals {
  cluster_labels              = var.f5xc_fleet_label != "" ? { "ves.io/fleet" = var.f5xc_fleet_label } : {}
  create_network              = var.subnet_outside_name != "" || (var.subnet_inside_name != "" && var.subnet_outside_name != "") ? true : false
  f5xc_secure_ce_slo_firewall = {
    rules = [
      {
        name        = "${var.project_name}-slo-allow-http-nat-t-ingress-${var.gcp_region}"
        priority    = 1000
        description = "Allow SLO INGRESS HTTPS and NAT-T"
        direction   = "INGRESS"
        target_tags = []
        ranges      = toset(concat(concat(var.f5xc_ip_ranges_americas, var.f5xc_ip_ranges_europe), var.f5xc_ip_ranges_asia))
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
        name        = "${var.project_name}-slo-allow-http-nat-t-egress-${var.gcp_region}"
        priority    = 1001
        description = "Allow SLO EGRESS HTTPS and NAT-T"
        direction   = "EGRESS"
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
        name        = "${var.project_name}-slo-allow-http-https-egress-${var.gcp_region}"
        priority    = 1002
        description = "Allow SLO EGRESS HTTP/HTTPS"
        direction   = "EGRESS"
        target_tags = []
        ranges      = var.f5xc_ce_egress_ip_ranges
        allow       = [
          {
            protocol = "tcp"
            ports    = ["443"]
          }
        ]
        deny       = []
        log_config = {
          metadata = "INCLUDE_ALL_METADATA"
        }
      },
      {
        name        = "${var.project_name}-slo-allow-ntp-egress-${var.gcp_region}"
        priority    = 1003
        description = "Allow SLO EGRESS NTP"
        direction   = "EGRESS"
        target_tags = []
        ranges      = ["0.0.0.0/0"]
        allow       = [
          {
            protocol = "udp"
            ports    = ["123"]
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
        description = "Allow SLO INGRESS SSH and IAP"
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
        name        = "${var.project_name}-slo-deny-all-egress-${var.gcp_region}"
        priority    = 65535
        description = "Deny SLO EGRESS ALL"
        direction   = "EGRESS"
        ranges      = ["0.0.0.0/0"]
        target_tags = []
        allow       = []
        deny        = [
          {
            protocol = "all"
            ports    = []
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
        description = "Allow SLI EGRESS SSH"
        direction   = "EGRESS"
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
        description = "Deny SLI ALL"
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