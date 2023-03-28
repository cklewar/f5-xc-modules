resource "volterra_nfv_service" "nfv" {
  name                     = var.f5xc_nfv_name
  namespace                = var.f5xc_namespace
  disable_ssh_access       = var.f5xc_nfv_disable_ssh_access
  enabled_ssh_access       = var.f5xc_nfv_enabled_ssh_access
  disable_https_management = var.f5xc_nfv_disable_https_management

  dynamic "https_management" {
    for_each = var.f5xc_nfv_disable_https_management ? [] : [1]

    content {
      domain_suffix                   = var.f5xc_nfv_domain_suffix
      do_not_advertise                = var.f5xc_https_mgmt_do_not_advertise
      advertise_on_public_default_vip = var.f5xc_https_mgmt_advertise_on_public_default_vip
      default_https_port              = var.f5xc_https_mgmt_default_https_port

      disable_local = var.f5xc_https_mgmt_disable_local

      dynamic "advertise_on_slo_sli" {
        for_each = var.f5xc_https_mgmt_advertise_on_slo_sli ? [1] : []
        content {
          use_mtls = false
          no_mtls  = true

          dynamic "tls_certificates" {
            for_each = ""
            content {
              certificate_url        = ""
              description            = ""
              disable_ocsp_stapling  = true
              custom_hash_algorithms = null
              use_system_defaults    = null
            }
          }

          tls_config {
            default_security = true
            medium_security  = false
            low_security     = false

            dynamic "custom_security" {
              for_each = var.f5xc_https_management_tls_config_custom_security
              content {
                cipher_suites = custom_security.value.cipher_suites
                max_version   = custom_security.value.max_version
                min_version   = custom_security.value.min_version
              }
            }
          }
        }
      }

      advertise_on_sli_vip {}

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

      advertise_on_slo_internet_vip {}
      advertise_on_internet_default_vip = var.f5xc_https_mgmt_advertise_on_internet_default_vip
    }
  }

  dynamic "big_ip_aws_service" {
    for_each = var.f5xc_nfv_type == var.f5xc_nfv_type_f5_big_ip_aws_service ? [1] : []

    content {
      tags           = var.custom_tags
      ssh_key        = var.ssh_public_key
      admin_username = var.f5xc_nfv_admin_username

      admin_password {
        clear_secret_info = {
          url = base64encode(var.f5xc_nfv_admin_password)
        }
      }

      dynamic "endpoint_service" {
        for_each = var.f5xc_nfv_endpoint_service

        content {
          advertise_on_slo_ip          = endpoint_service.value.advertise_on_slo_ip
          disable_advertise_on_slo_ip  = endpoint_service.value.disable_advertise_on_slo_ip
          advertise_on_slo_ip_external = endpoint_service.value.advertise_on_slo_ip_external
          default_tcp_ports            = endpoint_service.value.default_tcp_ports
          no_udp_ports                 = endpoint_service.value.no_udp_ports
        }
      }

      dynamic "byol_image" {
        for_each = var.f5xc_aws_service_byol_image
        content {
          image = byol_image.value.image
          license {
            dynamic "clear_secret_info" {
              for_each = byol_image.value.license.clear_secret_info ? [1] : []
              content {
                clear_secret_info {
                  url = base64encode(byol_image.value.license.clear_secret_info.url)
                }
              }
            }
          }
        }
      }

      dynamic "market_place_image" {
        for_each = var.f5xc_big_ip_aws_service_market_place_image_AWAFPayG3Gbps || var.f5xc_big_ip_aws_service_market_place_image_AWAFPayG200Mbps ? [1] : []
        content {
          AWAFPayG3Gbps   = var.f5xc_big_ip_aws_service_market_place_image_AWAFPayG3Gbps
          AWAFPayG200Mbps = var.f5xc_big_ip_aws_service_market_place_image_AWAFPayG200Mbps
        }
      }

      nodes {
        node_name            = var.f5xc_nfv_node_name
        aws_az_name          = var.f5xc_aws_az_name
        tunnel_prefix        = var.f5xc_nfv_service_node_tunnel_prefix
        automatic_prefix     = var.f5xc_nfv_service_node_tunnel_prefix == "" ? true : false
        reserved_mgmt_subnet = var.f5xc_nodes_reserved_mgmt_subnet

        dynamic "mgmt_subnet" {
          for_each = var.f5xc_nodes_reserved_mgmt_subnet
          content {
            existing_subnet_id = mgmt_subnet.value.existing_subnet_id
            subnet_param {
              ipv4 = mgmt_subnet.value.subnet_param.ipv4
              ipv6 = mgmt_subnet.value.subnet_param.ipv6
            }
          }
        }
      }

      dynamic "aws_vpc_site_params" {
        for_each = var.f5xc_nfv_aws_vpc_site_params
        content {
          aws_vpc_site {
            name      = aws_vpc_site_params.value.name
            tenant    = aws_vpc_site_params.value.tenant
            namespace = aws_vpc_site_params.value.namespace
          }
        }
      }

      dynamic "aws_tgw_site_params" {
        for_each = var.f5xc_nfv_aws_tgw_site_params
        content {
          aws_tgw_site {
            name      = aws_tgw_site_params.value.name
            tenant    = aws_tgw_site_params.value.tenant
            namespace = aws_tgw_site_params.value.namespace
          }
        }
      }
    }
  }

  dynamic "palo_alto_fw_service" {
    for_each = var.f5xc_nfv_type == var.f5xc_nfv_type_palo_alto_fw_service ? [1] : []

    content {
      tags           = var.custom_tags
      ssh_key        = var.ssh_public_key
      admin_username = var.f5xc_nfv_admin_username

      admin_password {
        clear_secret_info = {
          url = base64encode(var.f5xc_nfv_admin_password)
        }
      }

      dynamic "endpoint_service" {
        for_each = var.f5xc_nfv_endpoint_service

        content {
          advertise_on_slo_ip          = endpoint_service.value.advertise_on_slo_ip
          disable_advertise_on_slo_ip  = endpoint_service.value.disable_advertise_on_slo_ip
          advertise_on_slo_ip_external = endpoint_service.value.advertise_on_slo_ip_external
          default_tcp_ports            = endpoint_service.value.default_tcp_ports
          no_udp_ports                 = endpoint_service.value.no_udp_ports
        }
      }

      dynamic "byol_image" {
        for_each = var.f5xc_aws_service_byol_image
        content {
          image = byol_image.value.image
          license {
            dynamic "clear_secret_info" {
              for_each = byol_image.value.license.clear_secret_info ? [1] : []
              content {
                clear_secret_info {
                  url = base64encode(byol_image.value.license.clear_secret_info.url)
                }
              }
            }
          }
        }
      }

      dynamic "market_place_image" {
        for_each = var.f5xc_big_ip_aws_service_market_place_image_AWAFPayG3Gbps || var.f5xc_big_ip_aws_service_market_place_image_AWAFPayG200Mbps ? [1] : []
        content {
          AWAFPayG3Gbps   = var.f5xc_big_ip_aws_service_market_place_image_AWAFPayG3Gbps
          AWAFPayG200Mbps = var.f5xc_big_ip_aws_service_market_place_image_AWAFPayG200Mbps
        }
      }

      nodes {
        node_name            = var.f5xc_nfv_node_name
        aws_az_name          = var.f5xc_aws_az_name
        tunnel_prefix        = var.f5xc_nfv_service_node_tunnel_prefix
        automatic_prefix     = var.f5xc_nfv_service_node_tunnel_prefix == "" ? true : false
        reserved_mgmt_subnet = var.f5xc_nodes_reserved_mgmt_subnet

        dynamic "mgmt_subnet" {
          for_each = var.f5xc_nodes_reserved_mgmt_subnet
          content {
            existing_subnet_id = mgmt_subnet.value.existing_subnet_id
            subnet_param {
              ipv4 = mgmt_subnet.value.subnet_param.ipv4
              ipv6 = mgmt_subnet.value.subnet_param.ipv6
            }
          }
        }
      }

      dynamic "aws_vpc_site_params" {
        for_each = var.f5xc_nfv_aws_vpc_site_params
        content {
          aws_vpc_site {
            name      = aws_vpc_site_params.value.name
            tenant    = aws_vpc_site_params.value.tenant
            namespace = aws_vpc_site_params.value.namespace
          }
        }
      }

      dynamic "aws_tgw_site_params" {
        for_each = var.f5xc_nfv_aws_tgw_site_params
        content {
          aws_tgw_site {
            name      = aws_tgw_site_params.value.name
            tenant    = aws_tgw_site_params.value.tenant
            namespace = aws_tgw_site_params.value.namespace
          }
        }
      }
    }
  }
}

module "f5xc_nfv_wait_for_online" {
  depends_on             = [volterra_nfv_service.nfv]
  source                 = "../../status/nfv"
  f5xc_api_token         = local.f5xc_api_token
  f5xc_api_url           = var.f5xc_api_url
  f5xc_namespace         = var.f5xc_namespace
  f5xc_tenant            = local.f5xc_tenant
  f5xc_nfv_name          = var.f5xc_nfv_name
  f5xc_nfv_node_name     = var.f5xc_nfv_node_name
  f5xc_nfv_domain_suffix = var.f5xc_nfv_domain_suffix
}