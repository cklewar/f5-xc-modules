variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_origin_pool_name" {
  type = string
}

variable "f5xc_origin_pool_endpoint_selection" {
  type    = string
  default = "LOCAL_PREFERRED"

  validation {
    condition     = contains(["LOCAL_PREFERRED", "LOCAL_ONLY", "DISTRIBUTED"], var.f5xc_origin_pool_endpoint_selection)
    error_message = format("Valid values for f5xc_origin_pool_endpoint_selection: LOCAL_PREFERRED, LOCAL_ONLY, DISTRIBUTED")
  }
}

variable "f5xc_origin_pool_loadbalancer_algorithm" {
  type    = string
  default = "ROUND_ROBIN"

  validation {
    condition = contains([
      "ROUND_ROBIN", "LEAST_REQUEST", "RING_HASH", "LB_OVERRIDE", "RANDOM"
    ], var.f5xc_origin_pool_loadbalancer_algorithm)
    error_message = format("Valid values for f5xc_origin_pool_loadbalancer_algorithm: ROUND_ROBIN, LEAST_REQUEST, RING_HASH, LB_OVERRIDE, RANDOM")
  }

}

variable "f5xc_origin_pool_labels" {
  type    = map(string)
  default = {}
}

variable "f5xc_origin_pool_port" {
  type = string
}

variable "f5xc_origin_pool_no_tls" {
  type    = bool
  default = true
}

variable "f5xc_origin_pool_no_mtls" {
  type    = bool
  default = false
}

variable "f5xc_origin_pool_mtls_certificate_url" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_mtls_private_key_clear_secret_url" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_tls_skip_server_verification" {
  type    = bool
  default = true
}

variable "f5xc_origin_pool_custom_endpoint_object_name" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_k8s_service_name" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_k8s_service_site_locator_site_name" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_k8s_service_site_locator_virtual_site_name" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_tls_sni" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_tls_use_host_header_as_sni" {
  type    = bool
  default = false
}

variable "f5xc_origin_pool_tls_default_security" {
  type    = bool
  default = true
}

variable "f5xc_origin_pool_tls_low_security" {
  type    = bool
  default = false
}

variable "f5xc_origin_pool_tls_medium_security" {
  type    = bool
  default = false
}

variable "f5xc_origin_pool_tls_volterra_trusted_ca" {
  type    = bool
  default = false
}

variable "f5xc_origin_pool_tls_disable_sni" {
  type    = bool
  default = true
}

variable "f5xc_origin_pool_mtls_certificate_description" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_mtls_custom_hash_algorithms" {
  type    = list(string)
  default = []
}

variable "f5xc_origin_pool_same_as_endpoint_port" {
  type    = bool
  default = true
}

variable "f5xc_origin_pool_health_check_port" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_healthcheck_names" {
  type    = list(string)
  default = []
}

variable "f5xc_origin_pool_disable_outlier_detection" {
  type    = bool
  default = false
}

variable "f5xc_origin_pool_outlier_detection" {
  type = object({
    interval                    = optional(number)
    consecutive_5xx             = optional(number)
    base_ejection_time          = optional(number)
    max_ejection_percent        = optional(number)
    consecutive_gateway_failure = optional(number)
  })
  default = {}
}

variable "f5xc_origin_pool_origin_servers" {
  type = object(
    {
      public_ip = optional(list(object({
        ip = string
      })))
      public_name = optional(list(object({
        dns_name = string
      })))
      private_ip = optional(list(
        object({
          ip              = string
          inside_network  = bool
          outside_network = bool
          site_locator    = optional(object({
            site = object({
              name      = string
              namespace = string
            })
            virtual_site = optional(object({
              tenant    = string
              name      = string
              namespace = string
            }))
          }))
        })
      ))
    }
  )
  default = {}

  validation {
    condition     = length(var.f5xc_origin_pool_origin_servers) > 0
    error_message = "f5xc_origin_pool_origin_servers is a mandatory field."
  }
}

/*variable "f5xc_origin_pool_origin_servers" {
  type = list(object({
    public_ip = optional(object({
      ip = string
    }))
    public_name = optional(object({
      dns_name = string
    }))
    private_name = optional(object({
      dns_name        = string
      inside_network  = bool
      outside_network = bool
      site_locator    = optional(object({
        site = object({
          name      = string
          namespace = string
        })
        virtual_site = optional(object({
          tenant    = string
          name      = string
          namespace = string
        }))
      }))
    }))
    vn_private_name = optional(object({
      dns_name        = string
      private_network = object({
        tenant    = string
        name      = string
        namespace = string
      })
    }))
    private_ip = optional(object({
      ip              = string
      inside_network  = bool
      outside_network = bool
      site_locator    = optional(object({
        site = object({
          name      = string
          namespace = string
        })
        virtual_site = optional(object({
          tenant    = string
          name      = string
          namespace = string
        }))
      }))
    }))
    k8s_service = optional(object({
      service_name    = string
      inside_network  = bool
      outside_network = bool
      site_locator    = optional(object({
        site = object({
          name      = string
          namespace = string
        })
        virtual_site = optional(object({
          tenant    = string
          name      = string
          namespace = string
        }))
      }))
    }))
    consul_service = optional(object({
      service_name    = string
      inside_network  = bool
      outside_network = bool
      site_locator    = optional(object({
        site = object({
          name      = string
          namespace = string
        })
        virtual_site = optional(object({
          tenant    = string
          name      = string
          namespace = string
        }))
      }))
    }))
    vn_private_ip = optional(object({
      ip              = string
      virtual_network = object({
        tenant    = string
        name      = string
        namespace = string
      })
    }))
    custom_endpoint_object = optional(object({
      endpoint = object({
        tenant    = string
        name      = string
        namespace = string
      })
    }))
  }))
  default = []

  validation {
    condition     = length(var.f5xc_origin_pool_origin_servers) > 0
    error_message = "f5xc_origin_pool_origin_servers is a mandatory field."
  }
}*/