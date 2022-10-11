variable "f5xc_namespace" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_http_loadbalancer_name" {
  type = string
}

variable "f5xc_http_loadbalancer_advertise_on_public_public_ip_name" {
  type    = string
  default = ""
}

variable "f5xc_http_loadbalancer_do_not_advertise" {
  type    = bool
  default = false
}

variable "f5xc_http_loadbalancer_advertise_on_public_default_vip" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_disable_api_definition" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_no_challenge" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_domains" {
  type = list(string)
}

variable "f5xc_http_loadbalancer_round_robin" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_least_active" {
  type    = bool
  default = false
}

variable "f5xc_http_loadbalancer_random" {
  type    = bool
  default = false
}

variable "f5xc_http_loadbalancer_source_ip_stickiness" {
  type    = bool
  default = false
}

variable "f5xc_http_loadbalancer_cookie_stickiness" {
  type    = bool
  default = false
}

variable "f5xc_http_loadbalancer_ring_hash" {
  type    = bool
  default = false
}

variable "f5xc_http_loadbalancer_disable_rate_limit" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_user_id_client_ip" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_disable_waf" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_disable_learn_from_redirect_traffic" {
  type    = bool
  default = false
}

variable "f5xc_http_loadbalancer_add_location" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_disable_bot_defense" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_disable_ip_reputation" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_description" {
  type    = string
  default = ""
}

variable "f5xc_http_loadbalancer_type_https_auto_cert_add_hsts" {
  type    = bool
  default = false
}

variable "f5xc_http_loadbalancer_type_https_auto_cert_http_redirect" {
  type    = bool
  default = false
}

variable "f5xc_http_loadbalancer_type_https_auto_cert_http_port" {
  type    = number
  default = 443
}

variable "f5xc_http_loadbalancer_type_https_auto_cert_tls_config_high_security" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_type_https_auto_cert_tls_config_medium_security" {
  type    = bool
  default = null
}

variable "f5xc_http_loadbalancer_type_https_auto_cert_tls_config_low_security" {
  type    = bool
  default = null
}

variable "f5xc_http_loadbalancer_type_https_auto_cert_no_mtls" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_type_https_auto_cert_default_header" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_type_https_auto_cert_enable_path_normalize" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_default_route_pools" {
  type = list(object({
    pool = object({
      tenant    = string
      namespace = string
      name      = string
    })
    weight           = number
    priority         = number
    endpoint_subsets = map(string)
  }))
  default = [
    {
      pool = {
        tenant    = "playground-wtppvaog"
        namespace = "default"
        name      = "camera-1"
      }
      weight           = 1
      priority         = 1
      endpoint_subsets = {
        "ves.io/siteType" : "ves-io-ce"
      }
    },
    {
      pool = {
        tenant    = "playground-wtppvaog",
        namespace = "default",
        name      = "f5dc-hello"
      }
      weight           = 1
      priority         = 1
      endpoint_subsets = {
        "ves.io/interface" : "ip-fabric"
      }
    }
  ]
}

variable "f5xc_http_loadbalancer_rate_limit_server_url_rules" {
  type = list(object({
    any_domain          = bool
    specific_domain     = string
    base_path           = string
    inline_rate_limiter = object({
      threshold           = number
      unit                = string
      use_http_lb_user_id = bool
    })
  }))
  default = [
    {
      any_domain          = true
      specific_domain     = ""
      base_path           = "/"
      inline_rate_limiter = {
        threshold           = 1
        unit                = "SECOND"
        use_http_lb_user_id = true
      }
    },
    {
      any_domain          = true
      specific_domain     = ""
      base_path : "/"
      inline_rate_limiter = {
        threshold           = 1
        unit                = "SECOND"
        use_http_lb_user_id = true
      }
    },
    {
      any_domain          = false
      specific_domain     = "example.net"
      base_path : "/"
      inline_rate_limiter = {
        threshold           = 1
        unit                = "SECOND"
        use_http_lb_user_id = true
      }
    }
  ]
}

variable "f5xc_http_loadbalancer_api_rate_limit_no_ip_allowed_list" {
  type    = bool
  default = false
}

variable "f5xc_http_loadbalancer_service_policies_from_namespace" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_no_service_policies" {
  type    = bool
  default = false
}

variable "f5xc_http_loadbalancer_advertise_custom" {
  type = object({
    advertise_where = list(object({
      site = optional(object({
        network = string
        site    = object({
          tenant    = string
          namespace = string
          name      = string
        })
        ip = string
      }))
      virtual_site = optional(object({
        network      = string
        virtual_site = object({
          tenant    = string
          namespace = string
          name      = string
        })
      }))
      use_default_port = bool
      port             = string
    }))
  })
  default = {
    advertise_where = [
      {
        site = {
          network = "SITE_NETWORK_INSIDE_AND_OUTSIDE"
          site    = {
            tenant    = "playground-wtppvaog"
            namespace = "system"
            name      = "az-ac"
          }
          ip = ""
        }
        use_default_port = true
        port             = ""
      },
      {
        site = {
          network = "SITE_NETWORK_INSIDE"
          site    = {
            tenant    = "playground-wtppvaog"
            namespace = "system"
            name      = "aws-ac-2mnc"
          }
          ip = ""
        }
        use_default_port = true
        port             = ""
      },
      {
        site = {
          network : "SITE_NETWORK_OUTSIDE"
          site : {
            tenant : "playground-wtppvaog"
            namespace : "system"
            name : "aa-poc-ce-1"
          }
          ip = ""
        }
        use_default_port = true
        port             = ""
      },
      {
        site : {
          network : "SITE_NETWORK_SERVICE"
          site : {
            tenant : "playground-wtppvaog"
            namespace : "system"
            name : "az-ac-2mnc"
          }
          ip = ""
        }
        use_default_port = true
        port             = ""
      }
    ]
  }
}

variable "f5xc_loadbalancer_type_http" {
  type    = string
  default = "http"
}

variable "f5xc_loadbalancer_type_https" {
  type    = string
  default = "https"
}

variable "f5xc_loadbalancer_type_custom_https_auto_cert" {
  type    = string
  default = "https_auto_cert"
}

variable "f5xc_loadbalancer_type" {
  type = string

  validation {
    condition = contains([
      "https_auto_cert", "http", "https"
    ], var.f5xc_loadbalancer_type)
    error_message = format("Valid values for loadbalancer_type: https_auto_cert, http, https")
  }
}

variable "f5xc_http_loadbalancer_type_http_dns_volterra_managed" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_type_http_port" {
  type    = number
  default = 80
}

variable "f5xc_http_loadbalancer_type_https_port" {
  type    = number
  default = 443
}

variable "f5xc_http_loadbalancer_type_https_http_redirect" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_type_https_add_hsts" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_bot_defense" {
  type = object({
    regional_endpoint = string
    policy            = object({
      protected_app_endpoints = list(object({
        metadata = object({
          name        = string
          description = string
          disable     = bool
        })
        http_methods = list(string)
        protocol     = string
        any_domain   = bool
        path         = object({
          prefix = string
        })
        web        = bool
        mobile     = bool
        web_mobile = object({
          mobile_identifier = string
        })
        mitigation = object({
          flag = object({
            no_headers = bool
          })
          none  = bool
          block = object({
            body      = optional(string)
            status    = optional(string)
            body_hash = optional(string)
          })
        })
      }))
      js_insert_all_pages = object({
        javascript_location = string
      })
      js_download_path   = string
      disable_mobile_sdk = bool
    })
    timeout = number
  }), default = {}
}

/*
"bot_defense": {
      "regional_endpoint": "EU",
      "policy": {
        "protected_app_endpoints": [
          {
            "metadata": {
              "name": "app-ep-01",
              "description": null,
              "disable": null
            },
            "http_methods": [
              "GET"
            ],
            "protocol": "BOTH",
            "any_domain": {},
            "path": {
              "prefix": "/"
            },
            "web": {},
            "mitigation": {
              "flag": {
                "no_headers": {}
              }
            }
          }
        ],
        "js_insert_all_pages": {
          "javascript_location": "AFTER_HEAD"
        },
        "js_download_path": "/common.js",
        "disable_mobile_sdk": {}
      },
      "timeout": 1000
    },
*/

variable "f5xc_labels" {
  type    = map(string)
  default = {}
}