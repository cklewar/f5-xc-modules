resource "azurerm_marketplace_agreement" "f5xc" {
  publisher = var.f5xc_azure_marketplace_agreement_publisher
  offer     = var.f5xc_azure_marketplace_agreement_offer
  plan      = var.f5xc_azurer_marketplace_agreement_plan
}

resource "volterra_azure_vnet_site" "site" {
  name                     = var.f5xc_azure_site_name
  namespace                = var.f5xc_namespace
  default_blocked_services = var.f5xc_azure_default_blocked_services
  machine_type             = var.f5xc_azure_ce_machine_type

  azure_cred {
    name      = var.f5xc_azure_cred
    namespace = var.f5xc_namespace
    tenant    = var.f5xc_tenant
  }

  logs_streaming_disabled = var.f5xc_azure_logs_streaming_disabled
  azure_region            = var.f5xc_azure_region
  resource_group          = local.f5xc_azure_vnet_resource_group

  os {
    default_os_version       = var.f5xc_azure_default_ce_os_version
    operating_system_version = local.f5xc_azure_ce_os_version
  }
  sw {
    default_sw_version        = var.f5xc_azure_default_ce_sw_version
    volterra_software_version = local.f5xc_azure_ce_sw_version
  }

  dynamic "ingress_gw" {
    for_each = var.f5xc_azure_ce_gw_type == var.f5xc_nic_type_single_nic ? [1] : []
    content {
      azure_certified_hw = var.f5xc_azure_ce_certified_hw[var.f5xc_azure_ce_gw_type]
      local_control_plane {
        no_local_control_plane = var.f5xc_azure_no_local_control_plane
      }
      dynamic "az_nodes" {
        for_each = var.f5xc_azure_az_nodes
        content {
          azure_az  = tonumber(var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_azure_az"])
          disk_size = var.f5xc_azure_ce_disk_size

          local_subnet {
            dynamic "subnet_param" {
              for_each = var.f5xc_azure_vnet_name == "" && var.f5xc_azure_vnet_resource_group == "" && var.f5xc_azure_local_subnet_name == "" ? [1] : []
              content {
                ipv4 = var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_azure_vnet_local_subnet"]
              }
            }
            dynamic "subnet" {
              for_each = var.f5xc_azure_vnet_name != "" && var.f5xc_azure_vnet_resource_group != "" && var.f5xc_azure_local_subnet_name != "" ? [1] : []
              content {
                subnet_name = var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_azure_local_subnet_name"]
              }
            }
          }
        }
      }
    }
  }

  dynamic "ingress_egress_gw" {
    for_each = var.f5xc_azure_ce_gw_type == var.f5xc_nic_type_multi_nic ? [1] : []
    content {
      dynamic az_nodes {
        for_each = var.f5xc_azure_vnet_primary_ipv4 != "" && var.f5xc_azure_vnet_resource_group == "" ? var.f5xc_azure_az_nodes : {}
        content {
          azure_az  = tonumber(var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_azure_az"])
          disk_size = var.f5xc_azure_ce_disk_size

          inside_subnet {
            subnet {
              subnet_name = format("%s-%s", local.f5xc_azure_inside_subnet_name, az_nodes.key)
            }
            subnet_param {
              ipv4 = var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_azure_vnet_inside_subnet"]
            }
          }

          outside_subnet {
            subnet {
              subnet_name = format("%s-%s", local.f5xc_azure_outside_subnet_name, az_nodes.key)
            }
            subnet_param {
              ipv4 = var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_azure_vnet_outside_subnet"]
            }
          }
        }
      }

      dynamic az_nodes {
        for_each = var.f5xc_azure_vnet_primary_ipv4 == "" && var.f5xc_azure_vnet_resource_group != "" ? var.f5xc_azure_az_nodes : {}
        content {
          azure_az  = tonumber(var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_azure_az"])
          disk_size = var.f5xc_azure_ce_disk_size

          inside_subnet {
            subnet {
              subnet_name = var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_azure_vnet_inside_subnet_name"]
            }
          }

          outside_subnet {
            subnet {
              subnet_name = var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_azure_vnet_outside_subnet_name"]
            }
          }
        }
      }

      dynamic "global_network_list" {
        for_each = var.f5xc_azure_global_network_name
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
    }
    azure_certified_hw = var.f5xc_azure_ce_certified_hw[var.f5xc_azure_ce_gw_type]
    local_control_plane {
      no_local_control_plane = var.f5xc_azure_no_local_control_plane
    }

    no_global_network        = var.f5xc_azure_no_global_network
    no_outside_static_routes = var.f5xc_azure_no_outside_static_routes
    no_inside_static_routes  = var.f5xc_azure_no_inside_static_routes
    no_network_policy        = var.f5xc_azure_no_network_policy
    no_forward_proxy         = var.f5xc_azure_no_forward_proxy
  }

  vnet {
    dynamic "new_vnet" {
      for_each = var.f5xc_azure_vnet_primary_ipv4 != "" ? [1] : []
      content {
        name         = local.f5xc_azure_vnet_name
        primary_ipv4 = var.f5xc_azure_vnet_primary_ipv4
      }
    }
    dynamic "existing_vnet" {
      for_each = var.f5xc_azure_vnet_primary_ipv4 == "" && var.f5xc_azure_vnet_resource_group != "" ? [1] : []
      content {
        resource_group = local.f5xc_azure_vnet_resource_group
        vnet_name      = local.f5xc_azure_vnet_name
      }
    }
  }

  no_worker_nodes = var.f5xc_azure_no_worker_nodes
  nodes_per_az    = var.f5xc_azure_worker_nodes_per_az > 0 ? var.f5xc_azure_worker_nodes_per_az : null
  total_nodes     = var.f5xc_azure_total_worker_nodes > 0 ? var.f5xc_azure_total_worker_nodes : null
  ssh_key         = var.public_ssh_key
  lifecycle {
    ignore_changes = [labels]
  }
}

resource "volterra_cloud_site_labels" "labels" {
  name             = volterra_azure_vnet_site.site.name
  site_type        = var.f5xc_azure_site_kind
  # need at least one label, otherwise site_type is ignored
  labels           = merge({ "key" = "value" }, var.custom_tags)
  ignore_on_delete = var.f5xc_cloud_site_labels_ignore_on_delete
}

resource "volterra_tf_params_action" "azure_vnet_action" {
  site_name       = volterra_azure_vnet_site.site.name
  site_kind       = var.f5xc_azure_site_kind
  action          = var.f5xc_tf_params_action
  wait_for_action = var.f5xc_tf_wait_for_action
}