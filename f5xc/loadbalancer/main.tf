resource "volterra_http_loadbalancer" "loadbalancer" {
  name                            = var.f5xc_http_loadbalancer_name
  namespace                       = var.f5xc_namespace
  advertise_on_public_default_vip = var.f5xc_http_loadbalancer_advertise_on_public_default_vip
  advertise_on_public             = var.f5xc_http_loadbalancer_advertise_on_public
  advertise_custom                = var.f5xc_http_loadbalancer_advertise_custom
  do_not_advertise                = var.f5xc_http_loadbalancer_do_not_advertise
  disable_api_definition          = var.f5xc_http_loadbalancer_disable_api_definition
  api_definition                  = ""
  api_definitions                 = ""
  no_challenge                    = var.f5xc_http_loadbalancer_no_challenge
  js_challenge                    = ""
  captcha_challenge               = ""
  policy_based_challenge          = ""
  domains                         = var.f5xc_http_loadbalancer_domains
  round_robin                     = var.f5xc_http_loadbalancer_round_robin
  least_active                    = var.f5xc_http_loadbalancer_least_active
  random                          = var.f5xc_http_loadbalancer_random
  source_ip_stickiness            = var.f5xc_http_loadbalancer_source_ip_stickiness
  cookie_stickiness               = var.f5xc_http_loadbalancer_cookie_stickiness
  ring_hash                       = var.f5xc_http_loadbalancer_ring_hash

  dynamic "http" {
    for_each = ""
    content {
      dns_volterra_managed = var.f5xc_http_loadbalancer_dns_volterra_managed
      port                 = var.f5xc_http_loadbalancer_port
    }
  }

  dynamic "https" {
    for_each = ""
    content {

    }
  }

  https_auto_cert = ""

  single_lb_app {

    disable_discovery = true
    enable_discovery  = ""

    enable_discovery {
      enable_learn_from_redirect_traffic  = true
      disable_learn_from_redirect_traffic = ""
    }

    multi_lb_app                     = ""
    enable_ddos_detection            = true
    disable_ddos_detection           = ""
    enable_malicious_user_detection  = true
    disable_malicious_user_detection = ""

  }

  disable_rate_limit = var.f5xc_http_loadbalancer_disable_rate_limit
  api_rate_limit     = ""
  rate_limit         = ""

  active_service_policies {
    policies {
      name      = "test1"
      namespace = var.f5xc_namespace
      tenant    = var.f5xc_tenant
    }
  }

  service_policies_from_namespace = ""
  no_service_policies             = ""
  enable_trust_client_ip_headers {
    client_ip_headers = ["Client-IP-Header"]
  }
  disable_trust_client_ip_headers = ""
  user_id_client_ip               = var.f5xc_http_loadbalancer_user_id_client_ip
  user_identification             = ""
  disable_waf                     = var.f5xc_http_loadbalancer_disable_waf
  app_firewall                    = ""
  waf                             = ""
  waf_rule                        = ""
}