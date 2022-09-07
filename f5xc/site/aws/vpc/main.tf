resource "volterra_aws_vpc_site" "site" {
  name       = var.f5xc_aws_vpc_site_name
  namespace  = var.f5xc_namespace
  aws_region = var.f5xc_aws_region
  tags       = var.custom_tags
  labels     = var.f5xc_labels

  aws_cred {
    name      = var.f5xc_aws_cred
    namespace = var.f5xc_namespace
    tenant    = var.f5xc_tenant
  }

  dynamic "vpc" {
    for_each = var.f5xc_aws_vpc_existing_id == "" && var.f5xc_aws_vpc_primary_ipv4 != "" ? [1] : []
    content {
      new_vpc {
        name_tag     = var.f5xc_aws_vpc_name_tag
        primary_ipv4 = var.f5xc_aws_vpc_primary_ipv4
      }
    }
  }

  dynamic "vpc" {
    for_each = var.f5xc_aws_vpc_existing_id != "" && var.f5xc_aws_vpc_primary_ipv4 == "" ? [1] : []
    content {
      vpc_id = var.f5xc_aws_vpc_existing_id
    }
  }

  disk_size               = var.f5xc_aws_vpc_ce_instance_disk_size
  instance_type           = var.f5xc_aws_vpc_ce_instance_type
  logs_streaming_disabled = var.f5xc_aws_vpc_logs_streaming_disabled
  site_local_control_plane {
    no_local_control_plane = var.f5xc_aws_vpc_no_local_control_plane
  }

  os {
    default_os_version       = var.f5xc_aws_default_ce_os_version
    operating_system_version = local.f5xc_aws_ce_os_version
  }
  sw {
    default_sw_version        = var.f5xc_aws_default_ce_sw_version
    volterra_software_version = local.f5xc_aws_ce_sw_version
  }

  dynamic "ingress_gw" {
    for_each = var.f5xc_aws_ce_gw_type == var.f5xc_nic_type_single_nic ? [1] : []
    content {
      aws_certified_hw = var.f5xc_aws_ce_certified_hw[var.f5xc_aws_ce_gw_type]
      allowed_vip_port {
        use_http_https_port = var.f5xc_aws_vpc_use_http_https_port
      }

      dynamic "az_nodes" {
        for_each = var.f5xc_aws_vpc_az_nodes
        content {
          aws_az_name = var.f5xc_aws_vpc_az_nodes[az_nodes.key]["f5xc_aws_vpc_az_name"]
          disk_size   = var.f5xc_aws_vpc_ce_instance_disk_size

          dynamic "local_subnet" {
            for_each = var.f5xc_aws_vpc_primary_ipv4 != "" ? [1] : []
            content {
              subnet_param {
                ipv4 = var.f5xc_aws_vpc_az_nodes[az_nodes.key]["f5xc_aws_vpc_local_subnet"]
              }
            }
          }
          dynamic "local_subnet" {
            for_each = var.f5xc_aws_vpc_primary_ipv4 == "" ? [1] : []
            content {
              existing_subnet_id = var.f5xc_aws_vpc_az_nodes[az_nodes.key]["f5xc_aws_vpc_local_existing_subnet_id"]
            }
          }
        }
      }
    }
  }

  dynamic "ingress_egress_gw" {
    for_each = var.f5xc_aws_ce_gw_type == var.f5xc_nic_type_multi_nic ? [1] : []
    content {
      aws_certified_hw = var.f5xc_aws_ce_certified_hw[var.f5xc_aws_ce_gw_type]
      allowed_vip_port {
        use_http_https_port = var.f5xc_aws_vpc_use_http_https_port
      }
      allowed_vip_port_sli {
        use_http_https_port = var.f5xc_aws_vpc_use_http_https_port_sli
      }

      dynamic az_nodes {
        for_each = var.f5xc_aws_vpc_primary_ipv4 != "" && var.f5xc_aws_vpc_existing_id == "" ? var.f5xc_aws_vpc_az_nodes : {}
        content {
          aws_az_name = var.f5xc_aws_vpc_az_nodes[az_nodes.key]["f5xc_aws_vpc_az_name"]
          disk_size   = var.f5xc_aws_vpc_ce_instance_disk_size

          workload_subnet {
            subnet_param {
              ipv4 = var.f5xc_aws_vpc_az_nodes[az_nodes.key]["f5xc_aws_vpc_workload_subnet"]
            }
          }

          dynamic "inside_subnet" {
            for_each = contains(keys(var.f5xc_aws_vpc_az_nodes[az_nodes.key]), "f5xc_aws_vpc_inside_subnet") ? [1] : []
            content {
              subnet_param {
                ipv4 = var.f5xc_aws_vpc_az_nodes[az_nodes.key]["f5xc_aws_vpc_inside_subnet"]
              }
            }
          }

          outside_subnet {
            subnet_param {
              ipv4 = var.f5xc_aws_vpc_az_nodes[az_nodes.key]["f5xc_aws_vpc_outside_subnet"]
            }
          }
        }
      }

      dynamic az_nodes {
        for_each = var.f5xc_aws_vpc_primary_ipv4 == "" && var.f5xc_aws_vpc_existing_id != "" ? var.f5xc_aws_vpc_az_nodes : {}
        content {
          aws_az_name = var.f5xc_aws_vpc_az_nodes[az_nodes.key]["f5xc_aws_vpc_az_name"]
          disk_size   = var.f5xc_aws_vpc_ce_instance_disk_size

          workload_subnet {
            existing_subnet_id = var.f5xc_aws_vpc_az_nodes[az_nodes.key]["f5xc_aws_vpc_workload_existing_subnet_id"]
          }

          dynamic "inside_subnet" {
            for_each = contains(keys(var.f5xc_aws_vpc_az_nodes[az_nodes.key]), "f5xc_aws_vpc_inside_existing_subnet_id") ? [1] : []
            content {
              existing_subnet_id = var.f5xc_aws_vpc_az_nodes[az_nodes.key]["f5xc_aws_vpc_inside_existing_subnet_id"]
            }
          }

          outside_subnet {
            existing_subnet_id = var.f5xc_aws_vpc_az_nodes[az_nodes.key]["f5xc_aws_vpc_outside_existing_subnet_id"]
          }
        }
      }

      dynamic "global_network_list" {
        for_each = var.f5xc_aws_vpc_global_network_name
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

      no_global_network        = var.f5xc_aws_vpc_no_global_network
      no_outside_static_routes = var.f5xc_aws_vpc_no_outside_static_routes
      no_inside_static_routes  = var.f5xc_aws_vpc_no_inside_static_routes
      no_network_policy        = var.f5xc_aws_vpc_no_network_policy
      no_forward_proxy         = var.f5xc_aws_vpc_no_forward_proxy
    }
  }

  no_worker_nodes = var.f5xc_aws_vpc_no_worker_nodes
  nodes_per_az    = var.f5xc_aws_vpc_worker_nodes_per_az > 0 ? var.f5xc_aws_vpc_worker_nodes_per_az : null
  total_nodes     = var.f5xc_aws_vpc_total_worker_nodes > 0 ? var.f5xc_aws_vpc_total_worker_nodes : null
  ssh_key         = var.public_ssh_key
  lifecycle {
    ignore_changes = [labels]
  }
}

resource "volterra_cloud_site_labels" "labels" {
  name             = volterra_aws_vpc_site.site.name
  site_type        = var.f5xc_aws_site_kind
  # need at least one label, otherwise site_type is ignored
  labels           = merge({ "key" = "value" }, var.f5xc_labels)
  ignore_on_delete = var.f5xc_cloud_site_labels_ignore_on_delete
}

resource "volterra_tf_params_action" "aws_vpc_action" {
  site_name       = volterra_aws_vpc_site.site.name
  site_kind       = var.f5xc_aws_site_kind
  action          = var.f5xc_tf_params_action
  wait_for_action = var.f5xc_tf_wait_for_action
}