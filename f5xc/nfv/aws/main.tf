resource "volterra_nfv_service" "nfv" {
  name                     = var.f5xc_nfv_name
  namespace                = var.f5xc_namespace
  disable_ssh_access       = var.f5xc_nfv_disable_ssh_access
  disable_https_management = var.f5xc_nfv_disable_https_management

  dynamic "enabled_ssh_access" {
    for_each = var.f5xc_nfv_disable_ssh_access ? [] : [1]
    content {
      ssh_ports = var.f5xc_enabled_ssh_access_ssh_ports

      dynamic "advertise_on_public" {
        for_each = var.f5xc_enabled_ssh_access_advertise_on_public
        content {
          public_ip {
            name      = advertise_on_public.value.name
            tenant    = advertise_on_public.value.tenant
            namespace = advertise_on_public.value.namespace
          }
        }
      }
      advertise_on_public_default_vip = var.f5xc_enabled_ssh_access_advertise_on_public_default_vip ? var.f5xc_enabled_ssh_access_advertise_on_public_default_vip : null
    }
  }

  dynamic "https_management" {
    for_each = var.f5xc_nfv_disable_https_management ? [] : [1]

    content {
      domain_suffix                   = var.f5xc_nfv_domain_suffix
      disable_local                   = var.f5xc_https_mgmt_disable_local ? var.f5xc_https_mgmt_disable_local : null
      do_not_advertise                = var.f5xc_https_mgmt_do_not_advertise
      default_https_port              = var.f5xc_https_mgmt_default_https_port
      advertise_on_public_default_vip = var.f5xc_https_mgmt_advertise_on_public_default_vip ? var.f5xc_https_mgmt_advertise_on_public_default_vip : null

      dynamic "advertise_on_slo_sli" {
        for_each = var.f5xc_https_mgmt_advertise_on_slo_sli ? [1] : []
        content {
          use_mtls {}
          no_mtls = true

          dynamic "tls_certificates" {
            for_each = var.f5xc_https_mgmt_advertise_on_slo_sli_tls_certificates != null ? [1] : []
            content {
              description     = var.f5xc_https_mgmt_advertise_on_slo_sli_tls_certificates.description
              certificate_url = var.f5xc_https_mgmt_advertise_on_slo_sli_tls_certificates.certificate_url

              dynamic "use_system_defaults" {
                for_each = var.f5xc_https_mgmt_advertise_on_slo_sli_tls_certificates.use_system_defaults ? [1] : []
                content {}
              }

              dynamic "custom_hash_algorithms" {
                for_each = length(var.f5xc_https_mgmt_advertise_on_slo_sli_tls_certificates.custom_hash_algorithms) > 0 ? [1] : []
                content {
                  hash_algorithms = var.f5xc_https_mgmt_advertise_on_slo_sli_tls_certificates.custom_hash_algorithms
                }
              }
              disable_ocsp_stapling {}
            }
          }

          dynamic "tls_config" {
            for_each = var.f5xc_https_mgmt_advertise_on_slo_sli_tls_config != null ? [1] : []
            content {
              low_security     = var.f5xc_https_mgmt_advertise_on_slo_sli_tls_config.low_security
              medium_security  = var.f5xc_https_mgmt_advertise_on_slo_sli_tls_config.medium_security
              default_security = var.f5xc_https_mgmt_advertise_on_slo_sli_tls_config.default_security

              dynamic "custom_security" {
                for_each = var.f5xc_https_mgmt_advertise_on_slo_sli_tls_config.custom_security ? [1] : []
                content {
                  max_version   = var.f5xc_https_mgmt_advertise_on_slo_sli_tls_config.custom_security.max_version
                  min_version   = var.f5xc_https_mgmt_advertise_on_slo_sli_tls_config.custom_security.min_version
                  cipher_suites = var.f5xc_https_mgmt_advertise_on_slo_sli_tls_config.custom_security.cipher_suites
                }
              }
            }
          }
        }
      }

      dynamic "advertise_on_sli_vip" {
        for_each = var.f5xc_https_mgmt_advertise_on_sli_vip ? [1] : []
        content {}
      }

      dynamic "advertise_on_internet" {
        for_each = var.f5xc_https_mgmt_advertise_on_internet && var.f5xc_https_mgmt_advertise_on_internet_public_ip != "" ? [1] : []
        content {
          public_ip {
            name      = var.f5xc_https_mgmt_advertise_on_internet_public_ip
            tenant    = var.f5xc_tenant
            namespace = var.f5xc_namespace
          }
        }
      }

      dynamic "advertise_on_slo_internet_vip" {
        for_each = var.f5xc_https_mgmt_advertise_on_slo_internet_vip ? [1] : []
        content {}
      }
      advertise_on_internet_default_vip = var.f5xc_https_mgmt_advertise_on_internet_default_vip ?  var.f5xc_https_mgmt_advertise_on_internet_default_vip : null
    }
  }

  dynamic "f5_big_ip_aws_service" {
    for_each = var.f5xc_nfv_type == var.f5xc_nfv_type_f5_big_ip_aws_service ? [1] : []

    content {
      tags           = merge({ f5xc-tenant = var.f5xc_tenant }, var.custom_tags)
      ssh_key        = var.ssh_public_key
      admin_username = var.f5xc_nfv_admin_username

      admin_password {
        clear_secret_info {
          url = format("%s%s", "string:///", base64encode(var.f5xc_nfv_admin_password))
        }
      }

      endpoint_service {
        no_udp_ports                 = var.f5xc_nfv_endpoint_service.no_udp_ports
        no_tcp_ports                 = var.f5xc_nfv_endpoint_service.no_tcp_ports
        automatic_vip                = var.f5xc_nfv_endpoint_service.automatic_vip
        configured_vip               = var.f5xc_nfv_endpoint_service.configured_vip
        default_tcp_ports            = var.f5xc_nfv_endpoint_service.default_tcp_ports ? var.f5xc_nfv_endpoint_service.default_tcp_ports : null
        advertise_on_slo_ip          = var.f5xc_nfv_endpoint_service.advertise_on_slo_ip ? var.f5xc_nfv_endpoint_service.advertise_on_slo_ip : null
        disable_advertise_on_slo_ip  = var.f5xc_nfv_endpoint_service.disable_advertise_on_slo_ip ? var.f5xc_nfv_endpoint_service.disable_advertise_on_slo_ip : null
        advertise_on_slo_ip_external = var.f5xc_nfv_endpoint_service.advertise_on_slo_ip_external ? var.f5xc_nfv_endpoint_service.advertise_on_slo_ip_external : null
      }

      dynamic "byol_image" {
        for_each = var.f5xc_aws_service_byol_image != null ? [1] : []
        content {
          image = var.f5xc_aws_service_byol_image.image
          license {

            dynamic "clear_secret_info" {
              for_each = var.f5xc_aws_service_byol_image.license.clear_secret_info.url != "" ? [1] : []
              content {
                url = format("%s%s", "string:///", base64encode(var.f5xc_aws_service_byol_image.license.clear_secret_info.url))
              }
            }
          }
        }
      }

      dynamic "market_place_image" {
        for_each = var.f5xc_big_ip_aws_service_market_place_image_AWAFPayG3Gbps || var.f5xc_big_ip_aws_service_market_place_image_AWAFPayG200Mbps ? [1] : []
        content {
          awaf_pay_g3_gbps   = var.f5xc_big_ip_aws_service_market_place_image_AWAFPayG3Gbps ? var.f5xc_big_ip_aws_service_market_place_image_AWAFPayG3Gbps : null
          awaf_pay_g200_mbps = var.f5xc_big_ip_aws_service_market_place_image_AWAFPayG200Mbps ? var.f5xc_big_ip_aws_service_market_place_image_AWAFPayG200Mbps : null
        }
      }

      dynamic "nodes" {
        for_each = var.f5xc_aws_nfv_nodes
        content {
          node_name            = nodes.key
          aws_az_name          = var.f5xc_aws_nfv_nodes[nodes.key].aws_az_name
          tunnel_prefix        = var.f5xc_aws_nfv_nodes[nodes.key].tunnel_prefix
          automatic_prefix     = var.f5xc_aws_nfv_nodes[nodes.key].automatic_prefix
          reserved_mgmt_subnet = var.f5xc_aws_nfv_nodes[nodes.key].reserved_mgmt_subnet

          dynamic "mgmt_subnet" {
            for_each = lookup(var.f5xc_aws_nfv_nodes[nodes.key], "mgmt_subnet", null) != null ? [1] : []
            content {
              existing_subnet_id = var.f5xc_aws_nfv_nodes[nodes.key].mgmt_subnet.existing_subnet_id
              subnet_param {
                ipv4 = var.f5xc_aws_nfv_nodes[nodes.key].mgmt_subnet.subnet_param.ipv4
                ipv6 = var.f5xc_aws_nfv_nodes[nodes.key].mgmt_subnet.subnet_param.ipv6
              }
            }
          }
        }
      }

      dynamic "aws_vpc_site_params" {
        for_each = var.f5xc_nfv_aws_vpc_site_params != null ? [1] : []
        content {
          aws_vpc_site {
            name      = var.f5xc_nfv_aws_vpc_site_params.name
            tenant    = var.f5xc_nfv_aws_vpc_site_params.tenant
            namespace = var.f5xc_nfv_aws_vpc_site_params.namespace
          }
        }
      }

      dynamic "aws_tgw_site_params" {
        for_each = var.f5xc_nfv_aws_tgw_site_params != null ? [1] : []
        content {
          aws_tgw_site {
            name      = var.f5xc_nfv_aws_tgw_site_params.name
            tenant    = var.f5xc_nfv_aws_tgw_site_params.tenant
            namespace = var.f5xc_nfv_aws_tgw_site_params.namespace
          }
        }
      }
    }
  }

  dynamic "palo_alto_fw_service" {
    for_each = var.f5xc_nfv_type == var.f5xc_nfv_type_palo_alto_fw_service ? [1] : []

    content {
      tags             = var.custom_tags
      ssh_key          = var.ssh_public_key
      version          = var.f5xc_pan_version
      instance_type    = var.f5xc_pan_instance_type
      pan_ami_bundle1  = var.f5xc_pan_ami_bundle1
      pan_ami_bundle2  = var.f5xc_pan_ami_bundle2
      disable_panaroma = var.f5xc_pan_disable_panorama

      dynamic "panorama_server" {
        for_each = var.f5xc_pan_disable_panorama ? [] : [1]
        content {
          server              = var.f5xc_pan_panorama_server
          device_group_name   = var.f5xc_pan_panorama_device_group_name
          template_stack_name = var.f5xc_pan_panorama_template_stack_name
          authorization_key {
            clear_secret_info {
              url = format("%s%s", "string:///", base64encode(var.f5xc_pan_panorama_server_authorization_key))
            }
          }
        }
      }

      service_nodes {
        dynamic "nodes" {
          for_each = var.f5xc_aws_nfv_nodes
          content {
            node_name            = nodes.key
            aws_az_name          = var.f5xc_aws_nfv_nodes[nodes.key].aws_az_name
            reserved_mgmt_subnet = var.f5xc_aws_nfv_nodes[nodes.key].reserved_mgmt_subnet

            dynamic "mgmt_subnet" {
              for_each = lookup(var.f5xc_aws_nfv_nodes[nodes.key], "mgmt_subnet", null) != null ? [1] : []
              content {
                existing_subnet_id = var.f5xc_aws_nfv_nodes[nodes.key].mgmt_subnet.existing_subnet_id
                subnet_param {
                  ipv4 = var.f5xc_aws_nfv_nodes[nodes.key].mgmt_subnet.subnet_param.ipv4
                  ipv6 = var.f5xc_aws_nfv_nodes[nodes.key].mgmt_subnet.subnet_param.ipv6
                }
              }
            }
          }
        }
      }

      dynamic "auto_setup" {
        for_each = var.f5xc_pan_auto_setup ? [1] : []
        content {
          admin_username         = var.f5xc_nfv_admin_username
          autogenerated_ssh_keys = var.f5xc_pan_auto_setup_autogenerated_ssh_keys
          dynamic "manual_ssh_keys" {
            for_each = var.f5xc_pan_auto_setup_autogenerated_ssh_keys ? [] : [1]
            content {
              public_key = var.ssh_public_key
              private_key {
                clear_secret_info {
                  url = format("%s%s", "string:///", base64encode(var.ssh_private_key))
                }
              }
            }
          }
          admin_password {
            clear_secret_info {
              url = format("%s%s", "string:///", base64encode(var.f5xc_nfv_admin_password))
            }
          }
        }
      }

      dynamic "aws_tgw_site" {
        for_each = var.f5xc_nfv_aws_tgw_site_params != null ? [1] : []
        content {
          name      = var.f5xc_nfv_aws_tgw_site_params.name
          tenant    = var.f5xc_nfv_aws_tgw_site_params.tenant
          namespace = var.f5xc_nfv_aws_tgw_site_params.namespace
        }
      }
    }
  }
}

module "f5xc_nfv_wait_for_online" {
  depends_on             = [volterra_nfv_service.nfv]
  source                 = "../../status/nfv"
  for_each               = var.f5xc_enable_nfv_wait_for_online ? var.f5xc_aws_nfv_nodes : {}
  f5xc_api_token         = local.f5xc_api_token
  f5xc_api_url           = var.f5xc_api_url
  f5xc_namespace         = var.f5xc_namespace
  f5xc_tenant            = local.f5xc_tenant
  f5xc_nfv_name          = var.f5xc_nfv_name
  f5xc_nfv_node_name     = each.key
  f5xc_nfv_domain_suffix = var.f5xc_nfv_domain_suffix
}