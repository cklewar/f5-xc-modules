variable "restapi_write_returns_object" {
  type    = bool
  default = true
}

variable "restapi_debug" {
  type    = bool
  default = false
}

variable "f5xc_api_schema" {
  type    = string
  default = "https"
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_sms_base_uri" {
  type    = string
  default = "/config/namespaces/system/securemesh_site_v2s"
}

variable "f5xc_sms_master_nodes_count" {
  type = number
  validation {
    condition     = var.f5xc_sms_master_nodes_count == 1 || var.f5xc_sms_master_nodes_count == 3
    error_message = "Master node counter must be 1 or 3"
  }
}

variable "f5xc_sms_provider_name" {
  type = string
  validation {
    condition = contains(["rseries"], var.f5xc_sms_provider_name)
    error_message = format("Valid values for provider_name: rseries")
  }
}

variable "f5xc_sms_performance_enhancement_mode" {
  type = object({
    perf_mode_l7_enhanced = bool
    perf_mode_l3_enhanced = optional(object({
      jumbo = bool
    }))
  })
}

variable "f5xc_sms_enable_offline_survivability_mode" {
  type    = bool
  default = false
}

variable "f5xc_sms_disable" {
  type    = bool
  default = false
}

variable "f5xc_sms_description" {
  type    = string
  default = ""
}

variable "f5xc_sms_labels" {
  type = map(string)
  default = {}
}

variable "f5xc_sms_annotations" {
  type = map(string)
  default = {}
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_sms_name" {
  type = string
}

variable "f5xc_sms_software_settings" {
  type = object({
    sw = object({
      default_sw_version = bool
      volterra_software_version = optional(string)
    })
    os = object({
      default_os_version = bool
      operating_system_version = optional(string)
    })
  })
  default = {
    sw = {
      default_sw_version = true
    }
    os = {
      default_os_version = true
    }
  }
}

variable "f5xc_sms_block_all_services" {
  type    = bool
  default = false
}

variable "f5xc_sms_re_select" {
  type = object({
    geo_proximity = bool
  })
  default = {
    geo_proximity = true
  }
}

variable "f5xc_sms_tunnel_type" {
  type    = string
  default = "SITE_TO_SITE_TUNNEL_IPSEC_OR_SSL"
}

variable "f5xc_sms_tunnel_dead_timeout" {
  type    = number
  default = 0
}

variable "f5xc_sms_no_forward_proxy" {
  type    = bool
  default = true
}

variable "f5xc_sms_no_network_policy" {
  type    = bool
  default = true
}

variable "f5xc_sms_logs_streaming_disabled" {
  type    = bool
  default = true
}