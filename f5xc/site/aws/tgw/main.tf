resource "volterra_aws_tgw_site" "tgw" {
  name                    = var.f5xc_aws_tgw_name
  namespace               = var.f5xc_namespace
  logs_streaming_disabled = var.f5xc_aws_tgw_logs_streaming_disabled
  lifecycle {
    ignore_changes = [ labels, description ]
  }
  os {
    default_os_version       = var.f5xc_aws_default_ce_os_version
    operating_system_version = local.f5xc_aws_ce_os_version
  }
  sw {
    default_sw_version        = var.f5xc_aws_default_ce_sw_version
    volterra_software_version = local.f5xc_aws_ce_sw_version
  }
  tags                      = local.f5xc_aws_tgw_common_tags

  aws_parameters {
    aws_certified_hw = var.f5xc_aws_certified_hw
    aws_region       = var.f5xc_aws_region

    dynamic "az_nodes" {
      for_each = var.f5xc_aws_tgw_az_nodes
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

    new_vpc {
      allocate_ipv6 = var.f5xc_aws_tgw_vpc_allocate_ipv6
      autogenerate  = var.f5xc_aws_tgw_vpc_autogenerate
      primary_ipv4  = var.f5xc_aws_tgw_primary_ipv4
    }

    new_tgw {
      system_generated = var.f5xc_aws_tgw_vpc_system_generated
    }

    no_worker_nodes = var.f5xc_aws_tgw_no_worker_nodes
    nodes_per_az    = var.f5xc_aws_tgw_worker_nodes_per_az > 0 ? var.f5xc_aws_tgw_worker_nodes_per_az : null
    total_nodes     = var.f5xc_aws_tgw_total_worker_nodes > 0 ? var.f5xc_aws_tgw_total_worker_nodes : null
    ssh_key         = var.public_ssh_key
  }

  dynamic "vpc_attachments" {
    for_each = length(var.f5xc_aws_vpc_attachment_ids) > 0 ? [1] : []
    content {
      dynamic "vpc_list" {
        for_each = var.f5xc_aws_vpc_attachment_ids
        content {
          labels = {
            "deployment" = var.f5xc_aws_tgw_vpc_attach_label_deploy
          }
          vpc_id = vpc_list.value
        }
      }
    }
  }
}

resource "volterra_tf_params_action" "aws_tgw_action" {
  site_name       = volterra_aws_tgw_site.tgw.name
  site_kind       = var.f5xc_site_kind
  action          = var.f5xc_tf_params_action
  wait_for_action = true
}