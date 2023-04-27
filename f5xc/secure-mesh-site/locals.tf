locals {
  is_multi_node           = length(var.f5xc_secure_mesh_site_nodes) > 1 ? true : false
  is_multi_nic            = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? true : false
  secure_mesh_site_config = jsonencode({
    metadata : {
      name : var.f5xc_secure_mesh_name
      labels : var.f5xc_cluster_labels,
      namespace : var.f5xc_namespace,
    },
    disable : false
    annotations : {},
    spec : {
      volterra_certified_hw : var.f5xc_site_type_certified_hw[var.f5xc_site_type],
      master_node_configuration : [
        for node, attr in var.f5xc_secure_mesh_site_nodes : {
          name : node
        }
      ],
      worker_nodes : [],
      no_bond_devices : {},
      default_network_config : {},
      coordinates : {
        latitude : var.f5xc_site_latitude,
        longitude : var.f5xc_site_longitude,
      },
      logs_streaming_disabled : {},
      default_blocked_services : {},
      offline_survivability_mode : {
        no_offline_survivability_mode : {}
      }
    }
  })
}
