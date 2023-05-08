locals {
  is_multi_nic            = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? true : false
  create_network          = var.existing_network_outside == null || (var.existing_network_outside == null && var.existing_network_inside == null) ? true : false
  f5xc_cluster_labels     = merge({ ves-io-site-name = var.f5xc_cluster_name, ves-io-creator-id = var.owner }, var.f5xc_cluster_labels)
  f5xc_cluster_node_azs   = [for node in var.f5xc_ce_nodes : node["az"]]
  f5xc_ip_ranges_americas = concat(var.f5xc_ip_ranges_Americas_TCP, var.f5xc_ip_ranges_Americas_UDP)
  f5xc_ip_ranges_europe   = concat(var.f5xc_ip_ranges_Europe_TCP, var.f5xc_ip_ranges_Europe_UDP)
  f5xc_ip_ranges_asia     = concat(var.f5xc_ip_ranges_Asia_TCP, var.f5xc_ip_ranges_Asia_UDP)
  f5xc_ip_ranges_all      = concat(local.f5xc_ip_ranges_americas, concat(local.f5xc_ip_ranges_europe, local.f5xc_ip_ranges_asia))

  f5xc_secure_ce_slo_firewall_default = {
    rules = [
      {
        name        = format("%s-default-slo-ingress-allow-all", var.f5xc_cluster_name)
        priority    = 65534
        description = "DEFAULT SLO INGRESS ALLOW ALL RULE"
        direction   = "INGRESS"
        target_tags = []
        ranges      = ["0.0.0.0/0"]
        allow       = [
          {
            protocol = "all"
            ports    = []
          }
        ]
        deny       = []
        log_config = {
          metadata = "INCLUDE_ALL_METADATA"
        }
      }
    ]
  }

  f5xc_secure_ce_sli_firewall_default = {
    rules = [
      {
        name        = format("%s-default-sli-ingress-allow-all", var.f5xc_cluster_name)
        priority    = 65534
        description = "DEFAULT SLI INGRESS ALLOW ALL RULE"
        direction   = "INGRESS"
        target_tags = []
        ranges      = ["0.0.0.0/0"]
        allow       = [
          {
            protocol = "all"
            ports    = []
          }
        ]
        deny       = []
        log_config = {
          metadata = "INCLUDE_ALL_METADATA"
        }
      }
    ]
  }

  f5xc_secure_ce_slo_firewall = {
    rules = concat([
      {
        name        = "${var.f5xc_cluster_name}-slo-allow-http-nat-t-ingress-${var.gcp_region}"
        priority    = 1000
        description = "Allow SLO INGRESS HTTPS and NAT-T"
        direction   = "INGRESS"
        target_tags = []
        ranges      = toset(local.f5xc_ip_ranges_all)
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
        name        = "${var.f5xc_cluster_name}-slo-allow-http-nat-t-egress-${var.gcp_region}"
        priority    = 1001
        description = "Allow SLO EGRESS HTTPS and NAT-T"
        direction   = "EGRESS"
        target_tags = []
        ranges      = local.f5xc_ip_ranges_all
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
        name        = "${var.f5xc_cluster_name}-slo-allow-http-https-egress-${var.gcp_region}"
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
        name        = "${var.f5xc_cluster_name}-slo-allow-ntp-egress-${var.gcp_region}"
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
        name        = "${var.f5xc_cluster_name}-slo-allow-ssh-iap-ingress-${var.gcp_region}"
        priority    = 65534
        description = "Allow SLO INGRESS SSH and IAP"
        direction   = "INGRESS"
        ranges      = local.f5xc_ip_ranges_all
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
        name        = "${var.f5xc_cluster_name}-slo-deny-all-egress-${var.gcp_region}"
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
    ], var.f5xc_ce_slo_firewall.rules)
  }

  f5xc_secure_ce_sli_firewall = {
    rules = concat([
      {
        name        = "${var.f5xc_cluster_name}-sli-allow-ssh-egress-${var.gcp_region}"
        priority    = 65534
        description = "Allow SLO EGRESS NTP"
        direction   = "EGRESS"
        target_tags = []
        ranges      = ["0.0.0.0/0"]
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
        name        = "${var.f5xc_cluster_name}-sli-deny-all-egress-${var.gcp_region}"
        priority    = 65535
        description = "Deny SLI EGRESS ALL"
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
    ], var.f5xc_ce_sli_firewall.rules)
  }
}