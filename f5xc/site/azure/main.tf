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
  resource_group          = var.f5xc_azure_vnet_site_resource_group

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

      dynamic "az_nodes" {
        for_each = var.f5xc_azure_az_nodes
        content {
          azure_az  = tonumber(var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_azure_az"])
          disk_size = var.f5xc_azure_ce_disk_size

          local_subnet {
            dynamic "subnet_param" {
              for_each = contains(keys(var.f5xc_azure_az_nodes[az_nodes.key]), "f5xc_azure_vnet_local_subnet") ? [1] : []
              content {
                ipv4 = var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_azure_vnet_local_subnet"]
              }
            }
            dynamic "subnet" {
              for_each = contains(keys(var.f5xc_azure_az_nodes[az_nodes.key]), "f5xc_azure_local_subnet_name") ? [1] : []
              content {
                subnet_name         = var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_azure_local_subnet_name"]
                vnet_resource_group = var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_same_as_vnet_resource_group"] == false ? false : true
                subnet_resource_grp = var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_same_as_vnet_resource_group"] == false ? var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_subnet_resource_grp_name"] : null
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
        for_each = var.f5xc_azure_az_nodes
        content {
          azure_az  = tonumber(var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_azure_az"])
          disk_size = var.f5xc_azure_ce_disk_size

          inside_subnet {
            dynamic "subnet_param" {
              for_each = contains(keys(var.f5xc_azure_az_nodes[az_nodes.key]), "f5xc_azure_vnet_inside_subnet") ? [1] : []
              content {
                ipv4 = var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_azure_vnet_inside_subnet"]
              }
            }
            dynamic "subnet" {
              for_each = contains(keys(var.f5xc_azure_az_nodes[az_nodes.key]), "f5xc_azure_vnet_inside_subnet_name") ? [1] : []
              content {
                subnet_name         = var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_azure_vnet_inside_subnet_name"]
                vnet_resource_group = var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_same_as_vnet_resource_group"] == false && var.f5xc_azure_existing_vnet_name != "" && var.f5xc_azure_existing_vnet_resource_group != "" ? false : true
                subnet_resource_grp = var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_same_as_vnet_resource_group"] == false ? var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_subnet_resource_grp_name"] : null
              }
            }
          }

          outside_subnet {
            dynamic "subnet_param" {
              for_each = contains(keys(var.f5xc_azure_az_nodes[az_nodes.key]), "f5xc_azure_vnet_outside_subnet") ? [1] : []
              content {
                ipv4 = var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_azure_vnet_outside_subnet"]
              }
            }
            dynamic "subnet" {
              for_each = contains(keys(var.f5xc_azure_az_nodes[az_nodes.key]), "f5xc_azure_vnet_outside_subnet_name") ? [1] : []
              content {
                subnet_name         = var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_azure_vnet_outside_subnet_name"]
                vnet_resource_group = var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_same_as_vnet_resource_group"] == false && var.f5xc_azure_existing_vnet_name != "" && var.f5xc_azure_existing_vnet_resource_group != "" ? false : true
                subnet_resource_grp = var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_same_as_vnet_resource_group"] == false ? var.f5xc_azure_az_nodes[az_nodes.key]["f5xc_subnet_resource_grp_name"] : null
              }
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

      dynamic "hub" {
        for_each = length(var.f5xc_azure_hub_spoke_vnets) > 0 ? [1] : []
        content {
          dynamic "spoke_vnets" {
            for_each = var.f5xc_azure_hub_spoke_vnets
            content {
              vnet {
                resource_group = spoke_vnets.value.resource_group
                vnet_name      = spoke_vnets.value.vnet_name
              }
              auto   = spoke_vnets.value.auto
              manual = spoke_vnets.value.manual
              labels = spoke_vnets.value.labels
            }
          }
          dynamic "express_route_enabled" {
            for_each = length(var.f5xc_azure_express_route_connections) > 0 ? [1] : []
            content {
              dynamic "connections" {
                for_each = var.f5xc_azure_express_route_connections
                content {
                  metadata {
                    name        = connections.value.name
                    description = connections.value.description
                  }
                  other_subscription {
                    circuit_id = connections.value.circuit_id
                  }
                  weight = connections.value.weight
                }
              }
              sku_standard  = var.f5xc_azure_express_route_sku_standard
              sku_high_perf = var.f5xc_azure_express_route_sku_high_perf
              sku_ergw1az   = var.f5xc_azure_express_route_sku_ergw1az
              sku_ergw2az   = var.f5xc_azure_express_route_sku_ergw2az
              gateway_subnet {
                dynamic "subnet_param" {
                  for_each = length(var.f5xc_azure_express_gateway_subnet) > 0 ? [1] : []
                  content {
                    ipv4 = var.f5xc_azure_express_gateway_subnet
                  }
                }
                auto = length(var.f5xc_azure_express_gateway_subnet) > 0 ? false : true
              }
              route_server_subnet {
                subnet_param {
                  ipv4 = var.f5xc_azure_express_route_server_subnet
                }
                dynamic "subnet_param" {
                  for_each = length(var.f5xc_azure_express_route_server_subnet) > 0 ? [1] : []
                  content {
                    ipv4 = var.f5xc_azure_express_route_server_subnet
                  }
                }
                auto = length(var.f5xc_azure_express_route_server_subnet) > 0 ? false : true
              }
            }
          }
        }
      }

      azure_certified_hw       = var.f5xc_azure_ce_certified_hw[var.f5xc_azure_ce_gw_type]
      no_global_network        = var.f5xc_azure_no_global_network
      no_outside_static_routes = var.f5xc_azure_no_outside_static_routes
      no_inside_static_routes  = var.f5xc_azure_no_inside_static_routes
      no_network_policy        = var.f5xc_azure_no_network_policy
      no_forward_proxy         = var.f5xc_azure_no_forward_proxy
    }
  }

  vnet {
    dynamic "new_vnet" {
      for_each = var.f5xc_azure_vnet_primary_ipv4 != "" && var.f5xc_azure_existing_vnet_name == "" && var.f5xc_azure_existing_vnet_resource_group == "" ? [1] : []
      content {
        autogenerate = var.f5xc_azure_new_vnet_name == "" ? true : false
        name         = var.f5xc_azure_new_vnet_name != "" ? var.f5xc_azure_new_vnet_name : null
        primary_ipv4 = var.f5xc_azure_vnet_primary_ipv4
      }
    }
    dynamic "existing_vnet" {
      for_each = var.f5xc_azure_vnet_primary_ipv4 == "" && var.f5xc_azure_existing_vnet_name != "" && var.f5xc_azure_existing_vnet_resource_group != "" ? [1] : []
      content {
        resource_group = var.f5xc_azure_existing_vnet_resource_group
        vnet_name      = var.f5xc_azure_existing_vnet_name
      }
    }
  }

  no_worker_nodes = var.f5xc_azure_no_worker_nodes
  nodes_per_az    = var.f5xc_azure_worker_nodes_per_az > 0 ? var.f5xc_azure_worker_nodes_per_az : null
  total_nodes     = var.f5xc_azure_total_worker_nodes > 0 ? var.f5xc_azure_total_worker_nodes : null
  ssh_key         = var.ssh_public_key
  lifecycle {
    ignore_changes = [labels]
  }
}

resource "volterra_cloud_site_labels" "labels" {
  name             = volterra_azure_vnet_site.site.name
  site_type        = var.f5xc_azure_site_kind
  # need at least one label, otherwise site_type is ignored
  labels           = merge({ "key" = "value" }, var.custom_labels)
  ignore_on_delete = var.f5xc_cloud_site_labels_ignore_on_delete
}

resource "volterra_tf_params_action" "azure_vnet_action" {
  site_name       = volterra_azure_vnet_site.site.name
  site_kind       = var.f5xc_azure_site_kind
  action          = var.f5xc_tf_params_action
  wait_for_action = var.f5xc_tf_wait_for_action
}

module "site_wait_for_online" {
  depends_on     = [volterra_tf_params_action.azure_vnet_action]
  source         = "../../status/site"
  f5xc_api_token = var.f5xc_api_token
  f5xc_api_url   = var.f5xc_api_url
  f5xc_namespace = var.f5xc_namespace
  f5xc_site_name = volterra_azure_vnet_site.site.name
  f5xc_tenant    = var.f5xc_tenant
}

resource "azurerm_route" "route" {
  depends_on = [module.site_wait_for_online]
  for_each            = {for route in var.f5xc_azure_vnet_static_routes : route.name => route}
  name                = each.value.name
  resource_group_name = volterra_azure_vnet_site.site.resource_group
  route_table_name    = each.value.route_table_name
  address_prefix      = each.value.address_prefix
  next_hop_type       = each.value.next_hop_type
}