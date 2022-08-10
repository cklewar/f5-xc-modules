resource "volterra_gcp_vpc_site" "site" {
  name                     = var.f5xc_gcp_site_name
  namespace                = var.f5xc_namespace
  description              = var.f5xc_gcp_description
  gcp_region               = var.f5xc_gcp_region
  instance_type            = var.f5xc_gcp_ce_instance_type
  logs_streaming_disabled  = var.f5xc_gcp_logs_streaming_disabled
  default_blocked_services = var.f5xc_gcp_default_blocked_services
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
    for_each = var.f5xc_gcp_ce_gw_type == var.f5xc_nic_type_single_nic ? [1] : [0]
    content {
      gcp_certified_hw = var.f5xc_gcp_ce_certified_hw[var.f5xc_gcp_ce_gw_type]
      gcp_zone_names   = var.f5xc_gcp_zone_names

      local_network {
        dynamic "new_network" {
          for_each = ""
          content {
            name = local.f5xc_gcp_outside_network_name
          }
        }
        dynamic "new_network_autogenerate" {
          for_each = ""
          content {
            autogenerate = var.f5xc_gcp_new_network_autogenerate
          }
        }
        dynamic "existing_network" {
          for_each = ""
          content {
            name = "network1"
          }
        }
      }

      local_subnet {
        dynamic "new_subnet" {
          for_each = ""
          content {
            primary_ipv4 = var.f5xc_gcp_local_primary_ipv4
            subnet_name  = local.f5xc_gcp_outside_subnet_name
          }
        }
        dynamic "new_subnet" {
          for_each = ""
          content {
            primary_ipv4 = "10.1.0.0/16"
            subnet_name  = "subnet1-in-network1"
          }
        }
      }

      local_control_plane {
        no_local_control_plane = var.f5xc_gcp_no_local_control_plane
      }

      node_number = var.f5xc_gcp_node_number
    }
  }

  dynamic "ingress_egress_gw" {
    for_each = var.f5xc_gcp_ce_gw_type == var.f5xc_nic_type_multi_nic ? [1] : [0]
    content {
      gcp_certified_hw = var.f5xc_gcp_ce_certified_hw[var.f5xc_gcp_ce_gw_type]
      gcp_zone_names   = var.f5xc_gcp_zone_names

      outside_network {
        new_network {
          name = local.f5xc_gcp_outside_network_name
        }
        new_network_autogenerate {
          autogenerate = var.f5xc_gcp_new_network_autogenerate
        }
      }

      outside_subnet {
        new_subnet {
          primary_ipv4 = var.f5xc_gcp_outside_primary_ipv4
          subnet_name  = local.f5xc_gcp_outside_subnet_name
        }
      }

      inside_network {
        new_network {
          name = local.f5xc_gcp_inside_network_name
        }
        new_network_autogenerate {
          autogenerate = var.f5xc_gcp_new_network_autogenerate
        }
      }

      inside_subnet {
        new_subnet {
          primary_ipv4 = var.f5xc_gcp_inside_primary_ipv4
          subnet_name  = local.f5xc_gcp_inside_subnet_name
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

      local_control_plane {
        no_local_control_plane = var.f5xc_gcp_no_local_control_plane
      }

      no_global_network        = var.f5xc_gcp_no_global_network
      no_outside_static_routes = var.f5xc_gcp_no_outside_static_routes
      no_inside_static_routes  = var.f5xc_gcp_no_inside_static_routes
      no_network_policy        = var.f5xc_gcp_no_network_policy
      no_forward_proxy         = var.f5xc_gcp_no_forward_proxy
      node_number              = var.f5xc_gcp_node_number
    }
  }

  ssh_key = var.public_ssh_key
}

resource "volterra_cloud_site_labels" "labels" {
  name             = volterra_gcp_vpc_site.site.name
  site_type        = var.f5xc_gcp_site_kind
  # need at least one label, otherwise site_type is ignored
  labels           = merge({ "key" = "value" }, var.custom_tags)
  ignore_on_delete = var.f5xc_cloud_site_labels_ignore_on_delete
}

resource "volterra_tf_params_action" "gcp_vpc_action" {
  site_name       = volterra_gcp_vpc_site.site.name
  site_kind       = var.f5xc_gcp_site_kind
  action          = var.f5xc_tf_params_action
  wait_for_action = var.f5xc_tf_wait_for_action
}