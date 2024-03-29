resource "volterra_gcp_vpc_site" "site" {
  name                     = var.f5xc_gcp_site_name
  namespace                = var.f5xc_namespace
  description              = var.f5xc_gcp_description
  gcp_region               = var.f5xc_gcp_region
  instance_type            = var.f5xc_gcp_ce_instance_type
  logs_streaming_disabled  = var.f5xc_gcp_logs_streaming_disabled
  default_blocked_services = var.f5xc_gcp_default_blocked_services
  labels                   = var.f5xc_labels
  gcp_labels               = var.f5xc_gcp_labels

  cloud_credentials {
    name      = var.f5xc_gcp_cred
    namespace = var.f5xc_namespace
    tenant    = var.f5xc_tenant
  }

  os {
    default_os_version       = var.f5xc_gcp_default_ce_os_version
    operating_system_version = local.f5xc_aws_ce_os_version
  }
  sw {
    default_sw_version        = var.f5xc_gcp_default_ce_sw_version
    volterra_software_version = local.f5xc_aws_ce_sw_version
  }

  dynamic "ingress_gw" {
    for_each = var.f5xc_gcp_ce_gw_type == var.f5xc_nic_type_single_nic ? [1] : []
    content {
      node_number      = var.f5xc_gcp_node_number
      gcp_zone_names   = var.f5xc_gcp_zone_names
      gcp_certified_hw = var.f5xc_gcp_ce_certified_hw[var.f5xc_gcp_ce_gw_type]

      dynamic "local_network" {
        for_each = var.f5xc_gcp_local_network_name != "" || (var.f5xc_gcp_local_network_name == "" && var.f5xc_gcp_new_network_autogenerate == true) || var.f5xc_gcp_existing_local_network_name != "" ? [
          1
        ] : []
        content {
          dynamic "new_network" {
            for_each = var.f5xc_gcp_local_primary_ipv4 != "" && var.f5xc_gcp_local_network_name != "" ? [1] : []
            content {
              name = var.f5xc_gcp_local_network_name
            }
          }
          dynamic "new_network_autogenerate" {
            for_each = var.f5xc_gcp_local_network_name == "" && var.f5xc_gcp_new_network_autogenerate == true ? [1] : []
            content {
              autogenerate = var.f5xc_gcp_new_network_autogenerate
            }
          }
          dynamic "existing_network" {
            for_each = var.f5xc_gcp_existing_local_network_name != "" ? [1] : []
            content {
              name = var.f5xc_gcp_existing_local_network_name
            }
          }
        }
      }

      dynamic "local_subnet" {
        for_each = (var.f5xc_gcp_local_primary_ipv4 != "" && var.f5xc_gcp_existing_local_subnet_name == "") || (var.f5xc_gcp_local_primary_ipv4 == "" && var.f5xc_gcp_existing_local_subnet_name != "") ? [1] : []
        content {
          dynamic "new_subnet" {
            for_each = var.f5xc_gcp_local_primary_ipv4 != "" && var.f5xc_gcp_existing_local_subnet_name == "" ? [1] : []
            content {
              primary_ipv4 = var.f5xc_gcp_local_primary_ipv4
              subnet_name  = var.f5xc_gcp_local_subnet_name != "" ? var.f5xc_gcp_local_subnet_name : null
            }
          }
          dynamic "existing_subnet" {
            for_each = var.f5xc_gcp_existing_local_subnet_name != "" ? [1] : []
            content {
              subnet_name = var.f5xc_gcp_existing_local_subnet_name
            }
          }
        }
      }
    }
  }

  dynamic "ingress_egress_gw" {
    for_each = var.f5xc_gcp_ce_gw_type == var.f5xc_nic_type_multi_nic ? [1] : []
    content {
      node_number              = var.f5xc_gcp_node_number
      gcp_zone_names           = var.f5xc_gcp_zone_names
      no_forward_proxy         = var.f5xc_gcp_no_forward_proxy
      gcp_certified_hw         = var.f5xc_gcp_ce_certified_hw[var.f5xc_gcp_ce_gw_type]
      no_network_policy        = var.f5xc_gcp_no_network_policy
      no_global_network        = var.f5xc_gcp_no_global_network
      no_inside_static_routes  = var.f5xc_gcp_no_inside_static_routes
      no_outside_static_routes = var.f5xc_gcp_no_outside_static_routes

      dynamic "outside_network" {
        for_each = var.f5xc_gcp_outside_network_name != "" || (var.f5xc_gcp_new_network_autogenerate == true && var.f5xc_gcp_outside_network_name == "") || (var.f5xc_gcp_existing_outside_network_name != "") ? [1] : []
        content {
          dynamic "new_network" {
            for_each = var.f5xc_gcp_outside_network_name != "" ? [1] : []
            content {
              name = var.f5xc_gcp_outside_network_name
            }
          }
          dynamic "new_network_autogenerate" {
            for_each = var.f5xc_gcp_new_network_autogenerate == true && var.f5xc_gcp_outside_network_name == "" ? [1] : []
            content {
              autogenerate = var.f5xc_gcp_new_network_autogenerate
            }
          }
          dynamic "existing_network" {
            for_each = var.f5xc_gcp_existing_outside_network_name != "" ? [1] : []
            content {
              name = var.f5xc_gcp_existing_outside_network_name
            }
          }
        }
      }

      dynamic "inside_network" {
        for_each = var.f5xc_gcp_inside_network_name != "" || (var.f5xc_gcp_new_network_autogenerate == true && var.f5xc_gcp_inside_network_name == "") || var.f5xc_gcp_existing_inside_network_name != "" ? [1] : []
        content {
          dynamic "new_network" {
            for_each = var.f5xc_gcp_inside_network_name != "" ? [1] : []
            content {
              name = var.f5xc_gcp_inside_network_name
            }
          }
          dynamic "new_network_autogenerate" {
            for_each = var.f5xc_gcp_new_network_autogenerate == true && var.f5xc_gcp_inside_network_name == "" ? [1] : []
            content {
              autogenerate = var.f5xc_gcp_new_network_autogenerate
            }
          }
          dynamic "existing_network" {
            for_each = var.f5xc_gcp_existing_inside_network_name != "" ? [1] : []
            content {
              name = var.f5xc_gcp_existing_inside_network_name
            }
          }
        }
      }

      dynamic "outside_subnet" {
        for_each = var.f5xc_gcp_outside_primary_ipv4 != "" || (var.f5xc_gcp_outside_primary_ipv4 == "" && var.f5xc_gcp_outside_subnet_name != "") ? [1] : []
        content {
          dynamic "new_subnet" {
            for_each = var.f5xc_gcp_outside_primary_ipv4 != "" ? [1] : []
            content {
              primary_ipv4 = var.f5xc_gcp_outside_primary_ipv4
              subnet_name  = var.f5xc_gcp_outside_subnet_name != "" ? var.f5xc_gcp_outside_subnet_name : null
            }
          }
          dynamic "existing_subnet" {
            for_each = var.f5xc_gcp_outside_primary_ipv4 == "" && var.f5xc_gcp_outside_subnet_name != "" ? [1] : []
            content {
              subnet_name = var.f5xc_gcp_outside_subnet_name
            }
          }
        }
      }

      dynamic "inside_subnet" {
        for_each = var.f5xc_gcp_inside_primary_ipv4 != "" || (var.f5xc_gcp_inside_primary_ipv4 == "" && var.f5xc_gcp_inside_subnet_name != "") ? [1] : []
        content {
          dynamic "new_subnet" {
            for_each = var.f5xc_gcp_inside_primary_ipv4 != "" ? [1] : []
            content {
              primary_ipv4 = var.f5xc_gcp_inside_primary_ipv4
              subnet_name  = var.f5xc_gcp_inside_subnet_name != "" ? var.f5xc_gcp_inside_subnet_name : null
            }
          }
          dynamic "existing_subnet" {
            for_each = var.f5xc_gcp_inside_primary_ipv4 == "" && var.f5xc_gcp_inside_subnet_name != "" ? [1] : []
            content {
              subnet_name = var.f5xc_gcp_inside_subnet_name
            }
          }
        }
      }

      dynamic "global_network_list" {
        for_each = var.f5xc_gcp_global_network_name
        content {
          global_network_connections {
            sli_to_global_dr {
              global_vn {
                name = global_network_list.value
              }
            }
          }
        }
      }

      dynamic "active_forward_proxy_policies" {
        for_each = var.f5xc_active_forward_proxy_policies
        content {
          forward_proxy_policies {
            name      = active_forward_proxy_policies.value.name
            tenant    = active_forward_proxy_policies.value.tenant
            namespace = active_forward_proxy_policies.value.namespace
          }
        }
      }

      dynamic "active_network_policies" {
        for_each = var.f5xc_active_network_policies
        content {
          network_policies {
            name      = active_network_policies.value.name
            tenant    = active_network_policies.value.tenant
            namespace = active_network_policies.value.namespace
          }
        }
      }

      dynamic "active_enhanced_firewall_policies" {
        for_each = var.f5xc_active_enhanced_firewall_policies
        content {
          enhanced_firewall_policies {
            name      = active_enhanced_firewall_policies.value.name
            tenant    = active_enhanced_firewall_policies.value.tenant
            namespace = active_enhanced_firewall_policies.value.namespace
          }
        }
      }
    }
  }

  ssh_key = var.ssh_public_key
  lifecycle {
    ignore_changes = [labels]
  }
}

/*resource "volterra_cloud_site_labels" "labels" {
  name             = volterra_gcp_vpc_site.site.name
  labels           = merge({ "key" = "value" }, var.f5xc_labels)
  site_type        = var.f5xc_gcp_site_kind
  ignore_on_delete = var.f5xc_cloud_site_labels_ignore_on_delete
}*/

resource "volterra_tf_params_action" "gcp_vpc_action" {
  action          = var.f5xc_tf_params_action
  site_name       = volterra_gcp_vpc_site.site.name
  site_kind       = var.f5xc_gcp_site_kind
  wait_for_action = var.f5xc_tf_wait_for_action
}

module "site_wait_for_online" {
  depends_on     = [volterra_tf_params_action.gcp_vpc_action]
  source         = "../../status/site"
  f5xc_api_token = var.f5xc_api_token
  f5xc_api_url   = var.f5xc_api_url
  f5xc_namespace = var.f5xc_namespace
  f5xc_site_name = volterra_gcp_vpc_site.site.name
  f5xc_tenant    = var.f5xc_tenant
}

/*
resource "google_compute_network_peering" "hub_to_spoke_a" {
  depends_on           = [module.site_wait_for_online]
  name                 = format("%s-hub-spoke-a-%s", var.project_prefix, var.project_suffix)
  network              = data.google_compute_network.hub.self_link
  peer_network         = google_compute_network.spoke_a.self_link
  import_custom_routes = true
  export_custom_routes = true
}

resource "google_compute_network_peering" "spoke_a_to_hub" {
  depends_on           = [module.site_wait_for_online]
  name                 = format("%s-spoke-a-hub-%s", var.project_prefix, var.project_suffix)
  network              = google_compute_network.spoke_a.self_link
  peer_network         = data.google_compute_network.hub.self_link
  import_custom_routes = true
  export_custom_routes = true
}

resource "google_compute_network_peering" "hub_to_spoke_b" {
  depends_on           = [module.site_wait_for_online]
  name                 = format("%s-hub-spoke-b-%s", var.project_prefix, var.project_suffix)
  network              = data.google_compute_network.hub.self_link
  peer_network         = google_compute_network.spoke_b.self_link
  import_custom_routes = true
  export_custom_routes = true
}

resource "google_compute_network_peering" "spoke_b_to_hub" {
  depends_on           = [module.site_wait_for_online]
  name                 = format("%s-hub-spoke-b-%s", var.project_prefix, var.project_suffix)
  network              = google_compute_network.spoke_b.self_link
  peer_network         = data.google_compute_network.hub.self_link
  import_custom_routes = true
  export_custom_routes = true
}
*/
