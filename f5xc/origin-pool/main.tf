resource "volterra_origin_pool" "origin-pool" {
  name                   = var.f5xc_origin_pool_name
  namespace              = var.f5xc_namespace
  endpoint_selection     = var.f5xc_origin_pool_endpoint_selection
  loadbalancer_algorithm = var.f5xc_origin_pool_loadbalancer_algorithm
  same_as_endpoint_port  = var.f5xc_origin_pool_same_as_endpoint_port
  health_check_port      = var.f5xc_origin_pool_health_check_port != "" ? var.f5xc_origin_pool_health_check_port : null

  origin_servers {
    dynamic "public_ip" {
      for_each = var.f5xc_origin_pool_public_ip != "" ? [1] : [0]
      content {
        ip = var.f5xc_origin_pool_public_ip
      }
    }

    dynamic "public_name" {
      for_each = var.f5xc_origin_pool_public_name != "" ? [1] : [0]
      content {
        dns_name = var.f5xc_origin_pool_public_name
      }
    }

    dynamic "private_name" {
      for_each = var.f5xc_origin_pool_private_name != "" ? [1] : [0]
      content {
        dns_name = var.f5xc_origin_pool_private_name
        dynamic "site_locator" {
          for_each = var.f5xc_origin_pool_private_name_site_locator != "" ? [1] : [0]
          content {
            site {
              tenant    = var.f5xc_tenant,
              namespace = var.f5xc_namespace,
              name      = var.f5xc_origin_pool_private_name_site_locator_site_name
            }
            inside_network  = var.f5xc_origin_pool_private_name_inside_network
            outside_network = var.f5xc_origin_pool_private_name_outside_network
          }
        }
      }
    }

    vn_private_name = var.f5xc_origin_pool_vn_private_name != "" ? var.f5xc_origin_pool_vn_private_name : null

    dynamic "private_ip" {
      for_each = var.f5xc_origin_pool_private_ip != "" ? [1] : [0]
      content {
        ip = var.f5xc_origin_pool_private_ip
      }
      dynamic "site_locator" {
        for_each = var.f5xc_origin_pool_private_ip_site_locator != "" ? [1] : [0]
        content {
          site {
            tenant    = var.f5xc_tenant,
            namespace = var.f5xc_namespace,
            name      = var.f5xc_origin_pool_private_ip_site_locator_site_name
          }
          inside_network  = var.f5xc_origin_pool_private_ip_inside_network
          outside_network = var.f5xc_origin_pool_private_ip_outside_network
        }
      }
    }

    dynamic "k8s_service" {
      for_each = var.f5xc_origin_pool_k8s_service_name != "" ? [1] : [0]
      content {
        service_name = var.f5xc_origin_pool_k8s_service_name
      }
    }   =
    consul_service = var.f5xc_origin_pool_consul_service != "" ? var.f5xc_origin_pool_consul_service : null
    vn_private_ip  = var.f5xc_origin_pool_vn_private_ip != "" ? var.f5xc_origin_pool_vn_private_ip : null

    dynamic "custom_endpoint_object" {
      for_each = var.f5xc_origin_pool_custom_endpoint_object_name != "" ? [1] : [0]
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

  port    = var.f5xc_origin_pool_port
  no_tls  = var.f5xc_origin_pool_no_tls
  use_tls = var.f5xc_origin_pool_use_tls
}