resource "volterra_aws_tgw_site" "site" {
  name                     = var.f5xc_aws_tgw_name
  tags                     = var.custom_tags
  labels                   = var.f5xc_aws_tgw_labels
  namespace                = var.f5xc_namespace
  description              = var.f5xc_aws_tgw_description
  annotations              = var.f5xc_aws_tgw_annotations
  direct_connect_disabled  = var.f5xc_aws_tgw_direct_connect_disabled
  logs_streaming_disabled  = var.f5xc_aws_tgw_logs_streaming_disabled
  default_blocked_services = var.f5xc_aws_tgw_default_blocked_services

  tgw_security {
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

  dynamic "direct_connect_enabled" {
    for_each = var.f5xc_aws_tgw_direct_connect_disabled == false ? [1] : []
    content {
      cloud_aggregated_prefix      = var.f5xc_aws_tgw_cloud_aggregated_prefix
      dc_connect_aggregated_prefix = var.f5xc_aws_tgw_dc_connect_aggregated_prefix
      manual_gw                    = var.f5xc_aws_tgw_direct_connect_manual_gw == true && var.f5xc_aws_tgw_direct_connect_hosted_vifs == false && var.f5xc_aws_tgw_direct_connect_standard_vifs == false ? true : null
      standard_vifs                = var.f5xc_aws_tgw_direct_connect_standard_vifs
      dynamic "hosted_vifs" {
        for_each = var.f5xc_aws_tgw_direct_connect_manual_gw == false && var.f5xc_aws_tgw_direct_connect_hosted_vifs != "" && var.f5xc_aws_tgw_direct_connect_standard_vifs == false ? [1] : []
        content {
          vifs = var.f5xc_aws_tgw_direct_connect_hosted_vifs
        }
      }
      custom_asn = var.f5xc_aws_tgw_direct_connect_custom_asn
      auto_asn   = var.f5xc_aws_tgw_direct_connect_custom_asn == 0 ? true : null
    }
  }

  vn_config {
    dynamic "global_network_list" {
      for_each = var.f5xc_aws_tgw_global_network_name
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
    no_global_network       = var.f5xc_aws_tgw_no_global_network
    sm_connection_pvt_ip    = var.f5xc_aws_tgw_sm_connection_public_ip ? false : true
    sm_connection_public_ip = var.f5xc_aws_tgw_sm_connection_public_ip
  }

  lifecycle {
    ignore_changes = [labels, description]
  }
  os {
    default_os_version       = var.f5xc_aws_default_ce_os_version
    operating_system_version = local.f5xc_aws_ce_os_version
  }
  sw {
    default_sw_version        = var.f5xc_aws_default_ce_sw_version
    volterra_software_version = local.f5xc_aws_ce_sw_version
  }

  aws_parameters {
    aws_certified_hw     = var.f5xc_aws_certified_hw
    aws_region           = var.f5xc_aws_region
    enable_internet_vip  = var.f5xc_aws_tgw_enable_internet_vip
    disable_internet_vip = var.f5xc_aws_tgw_enable_internet_vip ? false : true

    dynamic "az_nodes" {
      for_each = var.f5xc_aws_tgw_id == "" && var.f5xc_aws_tgw_primary_ipv4 != "" ? var.f5xc_aws_tgw_az_nodes : {}
      content {
        aws_az_name = var.f5xc_aws_tgw_az_nodes[az_nodes.key]["f5xc_aws_tgw_az_name"]
        disk_size   = var.f5xc_aws_tgw_ce_instance_disk_size

        workload_subnet {
          subnet_param {
            ipv4 = var.f5xc_aws_tgw_az_nodes[az_nodes.key]["f5xc_aws_tgw_workload_subnet"]
          }
        }

        dynamic "inside_subnet" {
          for_each = contains(keys(var.f5xc_aws_tgw_az_nodes[az_nodes.key]), "f5xc_aws_tgw_inside_subnet") ? [1] : []
          content {
            subnet_param {
              ipv4 = var.f5xc_aws_tgw_az_nodes[az_nodes.key]["f5xc_aws_tgw_inside_subnet"]
            }
          }
        }

        outside_subnet {
          subnet_param {
            ipv4 = var.f5xc_aws_tgw_az_nodes[az_nodes.key]["f5xc_aws_tgw_outside_subnet"]
          }
        }
      }
    }

    dynamic "az_nodes" {
      for_each = var.f5xc_aws_tgw_id == "" && var.f5xc_aws_tgw_primary_ipv4 == "" ? var.f5xc_aws_tgw_az_nodes : {}
      content {
        aws_az_name = var.f5xc_aws_tgw_az_nodes[az_nodes.key]["f5xc_aws_tgw_az_name"]
        disk_size   = var.f5xc_aws_tgw_ce_instance_disk_size

        workload_subnet {
          existing_subnet_id = var.f5xc_aws_tgw_az_nodes[az_nodes.key]["f5xc_aws_tgw_workload_existing_subnet_id"]
        }

        dynamic "inside_subnet" {
          for_each = contains(keys(var.f5xc_aws_tgw_az_nodes[az_nodes.key]), "f5xc_aws_tgw_inside_existing_subnet_id") ? [1] : []
          content {
            existing_subnet_id = var.f5xc_aws_tgw_az_nodes[az_nodes.key]["f5xc_aws_tgw_inside_existing_subnet_id"]
          }
        }

        outside_subnet {
          existing_subnet_id = var.f5xc_aws_tgw_az_nodes[az_nodes.key]["f5xc_aws_tgw_outside_existing_subnet_id"]
        }
      }
    }

    dynamic "az_nodes" {
      for_each = var.f5xc_aws_tgw_id != "" && var.f5xc_aws_tgw_primary_ipv4 == "" ? var.f5xc_aws_tgw_az_nodes : {}
      content {
        aws_az_name = var.f5xc_aws_tgw_az_nodes[az_nodes.key]["f5xc_aws_tgw_az_name"]
        disk_size   = var.f5xc_aws_tgw_ce_instance_disk_size

        workload_subnet {
          existing_subnet_id = var.f5xc_aws_tgw_az_nodes[az_nodes.key]["f5xc_aws_tgw_workload_existing_subnet_id"]
        }

        dynamic "inside_subnet" {
          for_each = contains(keys(var.f5xc_aws_tgw_az_nodes[az_nodes.key]), "f5xc_aws_tgw_inside_existing_subnet_id") ? [1] : []
          content {
            existing_subnet_id = var.f5xc_aws_tgw_az_nodes[az_nodes.key]["f5xc_aws_tgw_inside_existing_subnet_id"]
          }
        }

        outside_subnet {
          existing_subnet_id = var.f5xc_aws_tgw_az_nodes[az_nodes.key]["f5xc_aws_tgw_outside_existing_subnet_id"]
        }
      }
    }

    dynamic "az_nodes" {
      for_each = var.f5xc_aws_tgw_id != "" && var.f5xc_aws_tgw_primary_ipv4 != "" ? var.f5xc_aws_tgw_az_nodes : {}
      content {
        aws_az_name = var.f5xc_aws_tgw_az_nodes[az_nodes.key]["f5xc_aws_tgw_az_name"]
        disk_size   = var.f5xc_aws_tgw_ce_instance_disk_size

        workload_subnet {
          subnet_param {
            ipv4 = var.f5xc_aws_tgw_az_nodes[az_nodes.key]["f5xc_aws_tgw_workload_subnet"]
          }
        }

        dynamic "inside_subnet" {
          for_each = contains(keys(var.f5xc_aws_tgw_az_nodes[az_nodes.key]), "f5xc_aws_tgw_inside_subnet") ? [1] : []
          content {
            subnet_param {
              ipv4 = var.f5xc_aws_tgw_az_nodes[az_nodes.key]["f5xc_aws_tgw_inside_subnet"]
            }
          }
        }

        outside_subnet {
          subnet_param {
            ipv4 = var.f5xc_aws_tgw_az_nodes[az_nodes.key]["f5xc_aws_tgw_outside_subnet"]
          }
        }
      }
    }

    aws_cred {
      name      = var.f5xc_aws_cred
      namespace = var.f5xc_namespace
      tenant    = var.f5xc_tenant
    }
    instance_type = var.f5xc_aws_tgw_instance_type

    dynamic "new_vpc" {
      for_each = var.f5xc_aws_vpc_id == "" && var.f5xc_aws_tgw_primary_ipv4 != "" ? [1] : []
      content {
        allocate_ipv6 = var.f5xc_aws_tgw_vpc_allocate_ipv6
        autogenerate  = var.f5xc_aws_tgw_vpc_autogenerate
        primary_ipv4  = var.f5xc_aws_tgw_primary_ipv4
      }
    }

    vpc_id = var.f5xc_aws_vpc_id != "" && var.f5xc_aws_tgw_primary_ipv4 == "" ? var.f5xc_aws_vpc_id : null

    dynamic "existing_tgw" {
      for_each = var.f5xc_aws_tgw_asn != 0 && var.f5xc_aws_tgw_id != "" && var.f5xc_aws_tgw_site_asn != 0 ? [1] : []
      content {
        tgw_asn           = var.f5xc_aws_tgw_asn
        tgw_id            = var.f5xc_aws_tgw_id
        volterra_site_asn = var.f5xc_aws_tgw_site_asn
      }
    }

    dynamic "new_tgw" {
      for_each = var.f5xc_aws_tgw_asn == 0 && var.f5xc_aws_tgw_id == "" && var.f5xc_aws_tgw_site_asn == 0 ? [1] : []
      content {
        system_generated = var.f5xc_aws_tgw_vpc_system_generated
      }
    }

    no_worker_nodes = var.f5xc_aws_tgw_no_worker_nodes
    nodes_per_az    = var.f5xc_aws_tgw_no_worker_nodes != false && var.f5xc_aws_tgw_worker_nodes_per_az > 0 ? var.f5xc_aws_tgw_worker_nodes_per_az : null
    total_nodes     = var.f5xc_aws_tgw_no_worker_nodes != false && var.f5xc_aws_tgw_total_worker_nodes > 0 ? var.f5xc_aws_tgw_total_worker_nodes : null
    ssh_key         = var.ssh_public_key
  }

  dynamic "vpc_attachments" {
    for_each = length(var.f5xc_aws_vpc_attachment_ids) > 0 ? [1] : []
    content {
      dynamic "vpc_list" {
        for_each = var.f5xc_aws_vpc_attachment_ids
        content {
          labels = {
            "deployment" = var.f5xc_aws_tgw_vpc_attach_label_deploy != "" ? var.f5xc_aws_tgw_vpc_attach_label_deploy : null
          }
          vpc_id = vpc_list.value
        }
      }
    }
  }
}

resource "volterra_cloud_site_labels" "labels" {
  name             = volterra_aws_tgw_site.site.name
  site_type        = "aws_tgw_site"
  # need at least one label, otherwise site_type is ignored
  labels           = merge({ "key" = "value" }, var.f5xc_aws_tgw_labels)
  ignore_on_delete = var.f5xc_cloud_site_labels_ignore_on_delete
}

resource "volterra_tf_params_action" "aws_tgw_action" {
  site_name       = volterra_aws_tgw_site.site.name
  site_kind       = var.f5xc_site_kind
  action          = var.f5xc_tf_params_action
  wait_for_action = var.f5xc_tf_wait_for_action
}

module "site_wait_for_online" {
  depends_on     = [volterra_tf_params_action.aws_tgw_action]
  source         = "../../../status/site"
  f5xc_api_token = var.f5xc_api_token
  f5xc_api_url   = var.f5xc_api_url
  f5xc_namespace = var.f5xc_namespace
  f5xc_site_name = volterra_aws_tgw_site.site.name
  f5xc_tenant    = var.f5xc_tenant
  is_sensitive   = var.is_sensitive
}
