variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_token_base_uri" {
  type    = string
  default = "/register/namespaces/%s/tokens"
}

variable "f5xc_token_read_uri" {
  type    = string
  default = "/register/namespaces/%s/tokens/%s"
}

variable "f5xc_token_delete_uri" {
  type    = string
  default = "/register/namespaces/%s/tokens/%s"
}

variable "f5xc_sms_base_uri" {
  type    = string
  default = "/config/namespaces/%s/securemesh_site_v2s"
}

variable "f5xc_sms_read_uri" {
  type    = string
  default = "/config/namespaces/%s/securemesh_site_v2s/%s"
}

variable "f5xc_sms_delete_uri" {
  type    = string
  default = "/config/namespaces/%s/securemesh_site_v2s/%s"
}

variable "f5xc_sms_provider_name" {
  type = string
  validation {
    condition = contains(["rseries", "aws", "gcp", "azure", "kvm", "vmware", "baremetal"], var.f5xc_sms_provider_name)
    error_message = format("Valid values for provider_name: rseries")
  }
}

variable "f5xc_sms_master_nodes_count" {
  type = number
  validation {
    condition     = var.f5xc_sms_master_nodes_count == 1 || var.f5xc_sms_master_nodes_count == 3
    error_message = "Master node counter must be 1 or 3"
  }
}

variable "f5xc_sms_perf_mode_l7_enhanced" {
  type    = bool
  default = true
}

variable "f5xc_sms_perf_mode_l3_enhanced_jumbo" {
  type    = bool
  default = false
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

variable "f5xc_sms_default_sw_version" {
  type    = bool
  default = true
}

variable "f5xc_sms_default_os_version" {
  type    = bool
  default = true
}

variable "f5xc_sms_operating_system_version" {
  type    = string
  default = ""
}

variable "f5xc_sms_volterra_software_version" {
  type    = string
  default = ""
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

variable "f5xc_dc_cluster_group_slo_name" {
  type    = string
  default = null
}

variable "f5xc_dc_cluster_group_sli_name" {
  type    = string
  default = null
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_ce_interface_list" {
  type = list(object({
    mtu         = string
    name        = string
    monitor = string #optional(string, "Disabled")
    priority    = string
    description = string
  }))
  default = []
}