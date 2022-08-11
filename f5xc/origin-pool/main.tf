resource "volterra_origin_pool" "origin-pool" {
  name                   = var.f5xc_origin_pool_name
  namespace              = var.f5xc_namespace
  endpoint_selection     = var.f5xc_origin_pool_endpoint_selection
  loadbalancer_algorithm = var.f5xc_origin_pool_loadbalancer_algorithm
  same_as_endpoint_port  = var.f5xc_origin_pool_same_as_endpoint_port
  health_check_port      = var.f5xc_origin_pool_health_check_port != "" ? var.f5xc_origin_pool_health_check_port : null
  dynamic "healthcheck" {
    for_each = var.f5xc_origin_pool_healthcheck_name != "" ? [1] : []
    content {
      tenant    = var.f5xc_tenant
      namespace = var.f5xc_namespace
      name      = var.f5xc_origin_pool_healthcheck_name
    }
  }

  origin_servers {
    dynamic "public_ip" {
      for_each = var.f5xc_origin_pool_public_ip != "" ? [1] : []
      content {
        ip = var.f5xc_origin_pool_public_ip
      }
    }

    dynamic "public_name" {
      for_each = var.f5xc_origin_pool_public_name != "" ? [1] : []
      content {
        dns_name = var.f5xc_origin_pool_public_name
      }
    }

    dynamic "private_name" {
      for_each = var.f5xc_origin_pool_private_name != "" ? [1] : []
      content {
        dns_name = var.f5xc_origin_pool_private_name
        dynamic "site_locator" {
          for_each = var.f5xc_origin_pool_private_name_site_locator != "" || var.f5xc_origin_pool_private_name_site_locator_virtual_site_name != "" ? [1] : []
          content {
            dynamic "site" {
              for_each = var.f5xc_origin_pool_private_name_site_locator != "" ? [1] : []
              content {
                tenant    = var.f5xc_tenant
                namespace = var.f5xc_namespace
                name      = var.f5xc_origin_pool_private_name_site_locator_site_name
              }
            }
            dynamic "virtual_site" {
              for_each = var.f5xc_origin_pool_private_name_site_locator_virtual_site_name != "" ? [1] : []
              content {
                tenant    = var.f5xc_tenant
                namespace = var.f5xc_namespace
                name      = var.f5xc_origin_pool_private_name_site_locator_virtual_site_name
              }
            }
          }
        }
        inside_network  = var.f5xc_origin_pool_private_name_inside_network
        outside_network = var.f5xc_origin_pool_private_name_outside_network
      }
    }

    dynamic "vn_private_name" {
      for_each = var.f5xc_origin_pool_vn_private_dns_name != "" ? [1] : []
      content {
        dns_name = var.f5xc_origin_pool_vn_private_dns_name
        private_network {
          tenant    = var.f5xc_tenant
          namespace = var.f5xc_namespace
          name      = var.f5xc_origin_pool_vn_private_name_site_locator_site_name
        }
      }
    }

    dynamic "private_ip" {
      for_each = var.f5xc_origin_pool_private_ip != "" ? [1] : []
      content {
        ip = var.f5xc_origin_pool_private_ip
        dynamic "site_locator" {
          for_each = var.f5xc_origin_pool_private_ip_site_locator_site_name != "" || var.f5xc_origin_pool_private_ip_site_locator_virtual_site_name != "" ? [1] : []
          content {
            dynamic "site" {
              for_each = var.f5xc_origin_pool_private_ip_site_locator_site_name != "" ? [1] : []
              content {
                tenant    = var.f5xc_tenant
                namespace = var.f5xc_namespace
                name      = var.f5xc_origin_pool_private_ip_site_locator_site_name
              }
            }
            dynamic "virtual_site" {
              for_each = var.f5xc_origin_pool_private_ip_site_locator_virtual_site_name != "" ? [1] : []
              content {
                tenant    = var.f5xc_tenant
                namespace = var.f5xc_namespace
                name      = var.f5xc_origin_pool_private_ip_site_locator_virtual_site_name
              }
            }
          }
        }
        inside_network  = var.f5xc_origin_pool_private_ip_inside_network
        outside_network = var.f5xc_origin_pool_private_ip_outside_network
      }
    }

    dynamic "k8s_service" {
      for_each = var.f5xc_origin_pool_k8s_service_name != "" ? [1] : []
      content {
        service_name = var.f5xc_origin_pool_k8s_service_name
        dynamic "site_locator" {
          for_each = var.f5xc_origin_pool_k8s_service_site_locator_site_name != "" || var.f5xc_origin_pool_k8s_service_site_locator_virtual_site_name != "" ? [1] : []
          content {
            dynamic "site" {
              for_each = var.f5xc_origin_pool_k8s_service_site_locator_site_name != "" ? [1] : []
              content {
                tenant    = var.f5xc_tenant
                namespace = var.f5xc_namespace
                name      = var.f5xc_origin_pool_k8s_service_site_locator_site_name
              }
            }
            dynamic "virtual_site" {
              for_each = var.f5xc_origin_pool_k8s_service_site_locator_virtual_site_name != "" ? [1] : []
              content {
                tenant    = var.f5xc_tenant
                namespace = var.f5xc_namespace
                name      = var.f5xc_origin_pool_k8s_service_site_locator_virtual_site_name
              }
            }
          }
        }
        inside_network  = var.f5xc_origin_pool_k8s_service_inside_network
        outside_network = var.f5xc_origin_pool_k8s_service_outside_network
      }
    }

    dynamic "consul_service" {
      for_each = var.f5xc_origin_pool_consul_service != "" ? [1] : []
      content {
        service_name = var.f5xc_origin_pool_consul_service_name
        dynamic "site_locator" {
          for_each = var.f5xc_origin_pool_consul_service_site_locator_site_name != "" || var.f5xc_origin_pool_consul_service_site_locator_virtual_site_name != "" ? [1] : []
          content {
            dynamic "site" {
              for_each = var.f5xc_origin_pool_consul_service_site_locator_site_name != "" ? [1] : []
              content {
                tenant    = var.f5xc_tenant
                namespace = var.f5xc_namespace
                name      = var.f5xc_origin_pool_consul_service_site_locator_site_name
              }
            }
            dynamic "virtual_site" {
              for_each = var.f5xc_origin_pool_k8s_service_site_locator_virtual_site_name != "" ? [1] : []
              content {
                tenant    = var.f5xc_tenant
                namespace = var.f5xc_namespace
                name      = var.f5xc_origin_pool_consul_service_site_locator_virtual_site_name
              }
            }
          }
        }
        inside_network  = var.f5xc_origin_pool_consul_service_inside_network
        outside_network = var.f5xc_origin_pool_consul_service_outside_network
      }
    }

    dynamic "vn_private_ip" {
      for_each = var.f5xc_origin_pool_vn_private_ip != "" ? [1] : []
      content {
        ip = var.f5xc_origin_pool_vn_private_ip
        virtual_network {
          tenant    = var.f5xc_tenant
          namespace = var.f5xc_namespace
          name      = var.f5xc_origin_pool_vn_private_ip_virtual_network_name
        }
      }
    }

    dynamic "custom_endpoint_object" {
      for_each = var.f5xc_origin_pool_custom_endpoint_object_name != "" ? [1] : []
      content {
        endpoint {
          name      = var.f5xc_origin_pool_custom_endpoint_object_name
          namespace = var.f5xc_namespace
          tenant    = var.f5xc_tenant
        }
      }
    }
    labels = var.f5xc_origin_pool_labels
  }

  port   = var.f5xc_origin_pool_port
  no_tls = var.f5xc_origin_pool_no_tls
  dynamic "use_tls" {
    for_each = var.f5xc_origin_pool_no_tls == false ? [1] : []
    content {
      skip_server_verification = var.f5xc_origin_pool_tls_skip_server_verification
      disable_sni              = var.f5xc_origin_pool_tls_disable_sni
      sni                      = var.f5xc_origin_pool_tls_disable_sni == false ? var.f5xc_origin_pool_tls_sni : null
      use_host_header_as_sni   = var.f5xc_origin_pool_tls_use_host_header_as_sni
      volterra_trusted_ca      = var.f5xc_origin_pool_tls_volterra_trusted_ca
      tls_config {
        default_security = var.f5xc_origin_pool_tls_default_security
        medium_security  = var.f5xc_origin_pool_tls_medium_security
        low_security     = var.f5xc_origin_pool_tls_low_security
      }
      no_mtls = var.f5xc_origin_pool_no_mtls

      dynamic "use_mtls" {
        for_each = var.f5xc_origin_pool_no_mtls == false ? [1] : []
        content {
          tls_certificates {
            certificate_url = var.f5xc_origin_pool_mtls_certificate_url
            description     = var.f5xc_origin_pool_mtls_certificate_description
            custom_hash_algorithms {
              hash_algorithms = var.f5xc_origin_pool_mtls_custom_hash_algorithms
            }
            private_key {
              clear_secret_info {
                url = var.f5xc_origin_pool_mtls_private_key_clear_secret_url
              }
            }
          }
        }
      }
    }
  }
}