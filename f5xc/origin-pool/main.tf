resource "volterra_origin_pool" "origin-pool" {
  port                   = var.f5xc_origin_pool_port
  name                   = var.f5xc_origin_pool_name
  no_tls                 = var.f5xc_origin_pool_no_tls
  namespace              = var.f5xc_namespace
  health_check_port      = var.f5xc_origin_pool_health_check_port != "" ? var.f5xc_origin_pool_health_check_port : null
  endpoint_selection     = var.f5xc_origin_pool_endpoint_selection
  same_as_endpoint_port  = var.f5xc_origin_pool_same_as_endpoint_port
  loadbalancer_algorithm = var.f5xc_origin_pool_loadbalancer_algorithm

  dynamic "healthcheck" {
    for_each = var.f5xc_origin_pool_healthcheck_names
    content {
      name = healthcheck.value
    }
  }

  dynamic "origin_servers" {
    for_each = {for k, v in var.f5xc_origin_pool_origin_servers : k => v if v != null}

    content {
      labels = var.f5xc_origin_pool_labels
      dynamic "public_ip" {
        for_each = contains(keys(origin_servers), "public_ip") ? [1] : []
        content {
          ip = public_ip.value.ip
        }
      }

      dynamic "public_name" {
        for_each = contains(keys(origin_servers), "public_name") ? [1] : []
        content {
          dns_name = public_name.value.dns_name
        }
      }

      dynamic "private_name" {
        for_each = contains(keys(origin_servers), "private_name") ? [1] : []
        content {
          dns_name        = private_name.value.dns_name
          inside_network  = private_name.value.inside_network
          outside_network = private_name.value.outside_network

          dynamic "site_locator" {
            for_each = contains(keys(private_name.value), "site_locator") ? [1] : []
            content {
              dynamic "site" {
                for_each = contains(keys(site_locator.value), "site") ? [1] : []
                content {
                  tenant    = site.value.tenant
                  namespace = site.value.namespace
                  name      = site.value.name
                }
              }
              dynamic "virtual_site" {
                for_each = contains(keys(site_locator.value), "virtual_site") ? [1] : []
                content {
                  tenant    = virtual_site.value.tenant
                  namespace = virtual_site.value.namespace
                  name      = virtual_site.value.name
                }
              }
            }
          }
        }
      }

      dynamic "vn_private_name" {
        for_each = contains(keys(origin_servers), "vn_private_name") ? [1] : []
        content {
          dns_name = vn_private_name.value.dns_name
          private_network {
            tenant    = vn_private_name.value.private_network.tenant
            namespace = vn_private_name.value.private_network.namespace
            name      = vn_private_name.value.private_network.name
          }
        }
      }

      dynamic "private_ip" {
        for_each = contains(keys(origin_servers), "private_ip") ? [1] : []
        content {
          ip              = private_ip.value.ip
          inside_network  = private_ip.value.inside_network
          outside_network = private_ip.value.outside_network

          dynamic "site_locator" {
            for_each = contains(keys(private_ip.value), "site_locator") ? [1] : []
            content {

              dynamic "site" {
                for_each = contains(keys(site_locator.value), "site") ? [1] : []
                content {
                  tenant    = site.value.tenant
                  namespace = site.value.namespace
                  name      = site.value.name
                }
              }
              dynamic "virtual_site" {
                for_each = contains(keys(site_locator.value), "virtual_site") ? [1] : []
                content {
                  tenant    = virtual_site.value.tenant
                  namespace = virtual_site.value.namespace
                  name      = virtual_site.value.name
                }
              }
            }
          }
        }
      }

      dynamic "k8s_service" {
        for_each = contains(keys(origin_servers), "k8s_service") ? [1] : []
        content {
          service_name    = k8s_service.value.service_name
          inside_network  = k8s_service.value.inside_network
          outside_network = k8s_service.value.outside_network

          dynamic "site_locator" {
            for_each = contains(keys(k8s_service.value), "site_locator") ? [1] : []
            content {

              dynamic "site" {
                for_each = contains(keys(site_locator.value), "site") ? [1] : []
                content {
                  tenant    = site.value.tenant
                  namespace = site.value.namespace
                  name      = site.value.name
                }
              }
              dynamic "virtual_site" {
                for_each = contains(keys(site_locator.value), "virtual_site") ? [1] : []
                content {
                  tenant    = virtual_site.value.tenant
                  namespace = virtual_site.value.namespace
                  name      = virtual_site.value.name
                }
              }
            }
          }
        }
      }

      dynamic "consul_service" {
        for_each = contains(keys(origin_servers), "consul_service") ? [1] : []
        content {
          service_name    = consul_service.value.service_name
          inside_network  = consul_service.value.inside_network
          outside_network = consul_service.value.outside_network

          dynamic "site_locator" {
            for_each = contains(keys(consul_service.value), "site_locator") ? [1] : []
            content {

              dynamic "site" {
                for_each = contains(keys(site_locator.value), "site") ? [1] : []
                content {
                  tenant    = site.value.tenant
                  namespace = site.value.namespace
                  name      = site.value.name
                }
              }
              dynamic "virtual_site" {
                for_each = contains(keys(site_locator.value), "virtual_site") ? [1] : []
                content {
                  tenant    = virtual_site.value.tenant
                  namespace = virtual_site.value.namespace
                  name      = virtual_site.value.name
                }
              }
            }
          }
        }
      }

      dynamic "vn_private_ip" {
        for_each = contains(keys(origin_servers), "vn_private_ip") ? [1] : []
        content {
          ip = vn_private_ip.value.ip
          virtual_network {
            tenant    = vn_private_ip.value.virtual_network.tenant
            namespace = vn_private_ip.value.virtual_network.namespace
            name      = vn_private_ip.value.virtual_network.name
          }
        }
      }

      dynamic "custom_endpoint_object" {
        for_each = contains(keys(origin_servers), "custom_endpoint_object") ? [1] : []
        content {
          endpoint {
            name      = custom_endpoint_object.value.endpoint.name
            namespace = custom_endpoint_object.value.endpoint.namespace
            tenant    = custom_endpoint_object.value.endpoint.tenant
          }
        }
      }
    }
  }

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

  advanced_options {
    disable_outlier_detection = var.f5xc_origin_pool_disable_outlier_detection

    dynamic "outlier_detection" {
      for_each = var.f5xc_origin_pool_outlier_detection
      content {
        base_ejection_time          = var.f5xc_origin_pool_outlier_detection.base_ejection_time
        consecutive_5xx             = var.f5xc_origin_pool_outlier_detection.consecutive_5xx
        consecutive_gateway_failure = var.f5xc_origin_pool_outlier_detection.consecutive_gateway_failure
        interval                    = var.f5xc_origin_pool_outlier_detection.interval
        max_ejection_percent        = var.f5xc_origin_pool_outlier_detection.max_ejection_percent
      }
    }
  }
}