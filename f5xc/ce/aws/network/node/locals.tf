/*locals = {
secure_mesh_site_data            = {
      for site in var.f5xc_secure_mesh_site[provider] : {
        name = site.f5xc_cluster_name
        json = jsonencode(
          {
            metadata : {
              name : site.f5xc_cluster_name
              labels : site.f5xc_cluster_labels,
              namespace : var.f5xc_namespace,
            },
            disable : false
            annotations : {},
            spec : {
              volterra_certified_hw : var.f5xc_site_type_certified_hw[provider],
              master_node_configuration : [
                for node in keys(site.f5xc_nodes) : {
                  name : node
                }
              ],
              worker_nodes : [],
              no_bond_devices : {},
              default_network_config : {},
              coordinates : {
                latitude : site.f5xc_cluster_latitude,
                longitude : site.f5xc_cluster_longitude,
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
}*/