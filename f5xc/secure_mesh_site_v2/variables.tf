variable "f5xc_sms_provider_name" {
  type = string
  validation {
    condition = contains(["rseries"], var.provider_name)
    error_message = format("Valid values for provider_name: rseries")
  }
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

variable "f5xc_sms_disable_ha" {
  type    = bool
  default = true
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