resource "volterra_http_loadbalancer" "example" {
  name      = "acmecorp-web"
  namespace = "staging"

  // One of the arguments from this list "do_not_advertise advertise_on_public_default_vip advertise_on_public advertise_custom" must be set
  advertise_on_public_default_vip = true

  // One of the arguments from this list "disable_api_definition api_definition api_definitions" must be set
  disable_api_definition = true

  // One of the arguments from this list "no_challenge js_challenge captcha_challenge policy_based_challenge" must be set
  no_challenge = true

  domains = ["www.foo.com"]

  // One of the arguments from this list "round_robin least_active random source_ip_stickiness cookie_stickiness ring_hash" must be set
  round_robin = true

  // One of the arguments from this list "http https_auto_cert https" must be set

  http {
    dns_volterra_managed = true
    port                 = "80"
  }

  // One of the arguments from this list "multi_lb_app single_lb_app" must be set

  single_lb_app {
    // One of the arguments from this list "enable_discovery disable_discovery" must be set
    disable_discovery = true

    enable_discovery {
      // One of the arguments from this list "disable_learn_from_redirect_traffic enable_learn_from_redirect_traffic" must be set
      enable_learn_from_redirect_traffic = true
    }

    // One of the arguments from this list "enable_ddos_detection disable_ddos_detection" must be set
    enable_ddos_detection = true

    // One of the arguments from this list "enable_malicious_user_detection disable_malicious_user_detection" must be set
    enable_malicious_user_detection = true
  }
  // One of the arguments from this list "disable_rate_limit api_rate_limit rate_limit" must be set
  disable_rate_limit = true

  // One of the arguments from this list "service_policies_from_namespace no_service_policies active_service_policies" must be set

  active_service_policies {
    policies {
      name      = "test1"
      namespace = "staging"
      tenant    = "acmecorp"
    }
  }

  // One of the arguments from this list "disable_trust_client_ip_headers enable_trust_client_ip_headers" must be set

  enable_trust_client_ip_headers {
    client_ip_headers = ["Client-IP-Header"]
  }
  // One of the arguments from this list "user_id_client_ip user_identification" must be set
  user_id_client_ip = true
  // One of the arguments from this list "app_firewall disable_waf waf waf_rule" must be set
  disable_waf = true
}