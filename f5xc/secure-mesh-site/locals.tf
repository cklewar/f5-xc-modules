locals {
  secure_mesh_site_data = {
    name = var.f5xc_cluster_name
    json = jsonencode(
      {
        metadata : {
          name : var.f5xc_cluster_name
          labels : var.f5xc_cluster_labels,
          namespace : var.f5xc_namespace,
        },
        disable : false
        annotations : {},
        spec : {
          volterra_certified_hw : var.f5xc_site_type_certified_hw[var.f5xc_ce_gateway_type],
          master_node_configuration : [
            for node in keys(var.f5xc_nodes) : {
              name : node
            }
          ],
          worker_nodes : [],
          no_bond_devices : {},
          default_network_config : {},
          coordinates : {
            latitude : var.f5xc_cluster_latitude,
            longitude : var.f5xc_cluster_longitude,
          },
          logs_streaming_disabled : {},
          default_blocked_services : {},
          offline_survivability_mode : {
            no_offline_survivability_mode : {}
          }
        }
      }
    )
  }
}