resource "volterra_origin_pool" "origin-pool" {
  name                   = var.f5xc_origin_pool_name
  namespace              = var.f5xc_namespace
  endpoint_selection     = var.f5xc_origin_pool_endpoint_selection
  loadbalancer_algorithm = var.f5xc_origin_pool_loadbalancer_algorithm
  same_as_endpoint_port  = var.f5xc_origin_pool_same_as_endpoint_port
  health_check_port      = var.f5xc_origin_pool_health_check_port != "" ? var.f5xc_origin_pool_health_check_port : null

  origin_servers {
    public_ip       = var.f5xc_origin_pool_public_ip != "" ? var.f5xc_origin_pool_public_ip : null
    public_name     = var.f5xc_origin_pool_public_name != "" ? var.f5xc_origin_pool_public_name : null
    private_name    = var.f5xc_origin_pool_private_name != "" ? var.f5xc_origin_pool_private_name : null
    vn_private_name = var.f5xc_origin_pool_vn_private_name != "" ? var.f5xc_origin_pool_vn_private_name : null
    private_ip      = var.f5xc_origin_pool_private_ip != "" ? var.f5xc_origin_pool_private_ip : null
    k8s_service     = var.f5xc_origin_pool_k8s_service != "" ? var.f5xc_origin_pool_k8s_service : null
    consul_service  = var.f5xc_origin_pool_consul_service != "" ? var.f5xc_origin_pool_consul_service : null
    vn_private_ip   = var.f5xc_origin_pool_vn_private_ip != "" ? var.f5xc_origin_pool_vn_private_ip : null

    dynamic "custom_endpoint_object" {
      for_each = ""
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