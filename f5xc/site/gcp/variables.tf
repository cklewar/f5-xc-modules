variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_gcp_site_name" {
  type = string

  validation {
    condition     = length(var.f5xc_gcp_site_name) <= 37
    error_message = format("Max length for f5xc_gcp_site_name ist 37 characters")
  }
}

variable "f5xc_gcp_cred" {
  type = string
}

variable "f5xc_gcp_region" {
  type = string
}

variable "f5xc_gcp_zone_names" {
  type = list(string)
}

variable "f5xc_gcp_ce_instance_type" {
  type    = string
  default = "n1-standard-4"
}

variable "f5xc_gcp_local_primary_ipv4" {
  type    = string
  default = ""
}

variable "f5xc_gcp_outside_primary_ipv4" {
  type    = string
  default = ""
}

variable "f5xc_gcp_inside_primary_ipv4" {
  type    = string
  default = ""
}

variable "f5xc_gcp_outside_network_name" {
  type    = string
  default = ""
}

variable "f5xc_gcp_inside_subnet_name" {
  type    = string
  default = ""
}

variable "f5xc_gcp_inside_network_name" {
  type    = string
  default = ""
}

variable "f5xc_gcp_local_subnet_name" {
  type    = string
  default = ""
}

variable "f5xc_gcp_local_network_name" {
  type    = string
  default = ""
}

variable "f5xc_gcp_outside_subnet_name" {
  type    = string
  default = ""
}

variable "f5xc_gcp_existing_local_network_name" {
  type    = string
  default = ""
}

variable "f5xc_gcp_existing_local_subnet_name" {
  type    = string
  default = ""
}

variable "f5xc_gcp_existing_outside_network_name" {
  type    = string
  default = ""
}

variable "f5xc_gcp_existing_inside_network_name" {
  type    = string
  default = ""
}

variable "f5xc_gcp_node_number" {
  type = number
}

variable "f5xc_gcp_default_ce_os_version" {
  type = bool
}

variable "f5xc_gcp_ce_os_version" {
  type    = string
  default = ""
}

variable "f5xc_gcp_default_ce_sw_version" {
  type = bool
}

variable "f5xc_gcp_ce_sw_version" {
  type    = string
  default = ""
}

variable "f5xc_gcp_global_network_name" {
  type    = list(string)
  default = []
}

variable "f5xc_gcp_no_global_network" {
  type    = bool
  default = true
}

variable "f5xc_gcp_no_outside_static_routes" {
  type    = bool
  default = true
}

variable "f5xc_gcp_no_inside_static_routes" {
  type    = bool
  default = true
}

variable "f5xc_gcp_no_network_policy" {
  type    = bool
  default = true
}

variable "f5xc_gcp_no_forward_proxy" {
  type    = bool
  default = true
}

variable "f5xc_gcp_ce_gw_type" {
  type    = string
  default = "multi_nic"

  validation {
    condition     = contains(["multi_nic", "single_nic"], var.f5xc_gcp_ce_gw_type)
    error_message = format("Valid values for f5xc_gcp_ce_gw_type: multi_nic, single_nic")
  }
}

variable "f5xc_gcp_ce_certified_hw" {
  type    = map(string)
  default = {
    multi_nic  = "gcp-byol-multi-nic-voltmesh"
    single_nic = "gcp-byol-voltmesh"
    app_stack  = "gcp-byol-voltstack-combo"
  }
}

variable "f5xc_gcp_site_kind" {
  type    = string
  default = "gcp_vpc_site"
}

variable "f5xc_gcp_logs_streaming_disabled" {
  type    = bool
  default = true
}

variable "f5xc_gcp_default_blocked_services" {
  type = bool
}

variable "f5xc_gcp_new_network_autogenerate" {
  type    = bool
  default = false
}

variable "f5xc_gcp_no_local_control_plane" {
  type    = bool
  default = true
}

variable "f5xc_gcp_description" {
  type    = string
  default = ""
}

variable "f5xc_nic_type_single_nic" {
  type    = string
  default = "single_nic"
}

variable "f5xc_nic_type_multi_nic" {
  type    = string
  default = "multi_nic"
}

variable "ssh_public_key" {
  type = string
}

variable "f5xc_tf_wait_for_action" {
  type    = bool
  default = true
}

variable "f5xc_tf_params_action" {
  type    = string
  default = "apply"

  validation {
    condition     = contains(["apply", "plan"], var.f5xc_tf_params_action)
    error_message = format("Valid values for f5xc_tf_params_action: apply, plan")
  }
}

variable "f5xc_cloud_site_labels_ignore_on_delete" {
  type    = bool
  default = true
}

variable "f5xc_labels" {
  description = "Custom labels to set on resources"
  type        = map(string)
  default     = {}
}

variable "f5xc_gcp_labels" {
  type        = map(string)
  default     = {}
}