locals {
  create_network               = var.gcp_existing_network_slo == null ? true : false
  create_subnetwork            = var.gcp_existing_subnet_network_slo == null ? true : false
  f5xc_cluster_master_node_azs = [for node in var.f5xc_cluster_nodes.master : node["az"]]
  f5xc_cluster_worker_node_azs = [for node in var.f5xc_cluster_nodes.worker : node["az"]]

  f5xc_ce_slo_firewall_default = {
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
        deny = []
        log_config = {
          metadata = "INCLUDE_ALL_METADATA"
        }
      }
    ]
  }
}