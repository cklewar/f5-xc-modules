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
      gcp_certified_hw = var.f5xc_gcp_ce_certified_hw[var.f5xc_gcp_ce_gw_type]
      gcp_zone_names   = var.f5xc_gcp_zone_names
      node_number      = var.f5xc_gcp_node_number

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
      gcp_certified_hw = var.f5xc_gcp_ce_certified_hw[var.f5xc_gcp_ce_gw_type]
      gcp_zone_names   = var.f5xc_gcp_zone_names

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

      no_global_network        = var.f5xc_gcp_no_global_network
      no_outside_static_routes = var.f5xc_gcp_no_outside_static_routes
      no_inside_static_routes  = var.f5xc_gcp_no_inside_static_routes
      no_network_policy        = var.f5xc_gcp_no_network_policy
      no_forward_proxy         = var.f5xc_gcp_no_forward_proxy
      node_number              = var.f5xc_gcp_node_number
    }
  }
  ssh_key = var.ssh_public_key
}

resource "volterra_cloud_site_labels" "labels" {
  name             = volterra_gcp_vpc_site.site.name
  site_type        = var.f5xc_gcp_site_kind
  # need at least one label, otherwise site_type is ignored
  labels           = merge({ "key" = "value" }, var.f5xc_labels)
  ignore_on_delete = var.f5xc_cloud_site_labels_ignore_on_delete
}

resource "volterra_tf_params_action" "gcp_vpc_action" {
  site_name       = volterra_gcp_vpc_site.site.name
  site_kind       = var.f5xc_gcp_site_kind
  action          = var.f5xc_tf_params_action
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

/*resource "null_resource" "hcl2json_get" {
  depends_on = [module.site_wait_for_online]
  triggers   = {
    url      = var.hcl2json_bin_url
    filename = "hcl2json"
    version  = var.hcl2json_version
  }
  provisioner "local-exec" {
    command     = <<-EOT
      PLATFORM=$(echo "$(uname)" | tr '[:upper:]' '[:lower:]')
      ARCH=$(uname -m)
      curl -o ${path.module}/scripts/${self.triggers.filename} -X 'GET' 2>/dev/null ${self.triggers.url}/${self.triggers.version}/hcl2json_$PLATFORM_$ARCH
    EOT
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }
}*/