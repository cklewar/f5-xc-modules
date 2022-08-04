variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_cert" {
  default = ""
}

variable "f5xc_api_key" {
  default = ""
}

variable "f5xc_api_ca_cert" {
  default = ""
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_azure_site_name" {
  type = string
}

variable "f5xc_azure_cred" {
  type = string
}

variable "f5xc_azure_region" {
  type = string
}

variable "f5xc_azure_default_ce_os_version" {
  type = bool
}

variable "f5xc_azure_ce_os_version" {
  type    = string
  default = ""
}

variable "f5xc_azure_default_ce_sw_version" {
  type = bool
}

variable "f5xc_azure_ce_sw_version" {
  type    = string
  default = ""
}

variable "f5xc_azure_ce_machine_type" {
  type    = string
  default = "Standard_D4_v4"
}

variable "f5xc_azure_vnet_primary_ipv4" {
  type = string
}

variable "f5xc_azure_az_nodes" {
  type = map(map(string))
}

variable "f5xc_azure_global_network_name" {
  type    = list(string)
  default = []
}

variable "f5xc_azure_no_global_network" {
  type    = bool
  default = true
}

variable "f5xc_azure_no_outside_static_routes" {
  type    = bool
  default = true
}

variable "f5xc_azure_no_inside_static_routes" {
  type    = bool
  default = true
}

variable "f5xc_azure_no_network_policy" {
  type    = bool
  default = true
}

variable "f5xc_azure_no_forward_proxy" {
  type    = bool
  default = true
}

variable "f5xc_azure_ce_gw_type" {
  type    = string
  default = "multi_nic"

  validation {
    condition     = contains(["multi_nic", "single_nic"], var.f5xc_azure_ce_gw_type)
    error_message = format("Valid values for f5xc_azure_ce_gw_type: multi_nic, single_nic")
  }
}

variable "f5xc_azure_ce_certified_hw" {
  type    = map(string)
  default = {
    multi_nic  = "azure-byol-multi-nic-voltmesh"
    single_nic = "azure-byol-voltmesh"
    app_stack  = "azure-byol-voltstack-combo"
  }
}

variable "f5xc_azure_default_blocked_services" {
  type = bool
}

variable "f5xc_azure_logs_streaming_disabled" {
  type    = bool
  default = true
}

variable "f5xc_azure_no_local_control_plane" {
  type    = bool
  default = true
}

variable "f5xc_azure_site_kind" {
  type    = string
  default = "azure_vnet_site"
}

variable "f5xc_azure_ce_disk_size" {
  type    = string
  default = "80"
}

variable "public_ssh_key" {
  type = string
}

variable "f5xc_azure_worker_nodes_per_az" {
  type    = number
  default = 0
}

variable "f5xc_azure_total_worker_nodes" {
  type    = number
  default = 0
}

variable "f5xc_azure_no_worker_nodes" {
  type = bool
}

variable "f5xc_azure_vnet_resource_group" {
  type    = string
  default = ""
}

variable "f5xc_azure_vnet_name" {
  type    = string
  default = ""
}

variable "f5xc_azure_local_subnet_name" {
  type    = string
  default = ""
}

variable "f5xc_azure_marketplace_agreement_publisher" {
  type    = string
  default = "volterraedgeservices"
}

variable "f5xc_azure_marketplace_agreement_offer" {
  type    = string
  default = "entcloud_voltmesh_voltstack_node"
}

variable "f5xc_azurer_marketplace_agreement_plan" {
  type    = string
  default = "freeplan_entcloud_voltmesh_voltstack_node_multinic"
}

variable "f5xc_tf_params_action" {
  type    = string
  default = "apply"

  validation {
    condition     = contains(["apply", "plan"], var.f5xc_tf_params_action)
    error_message = format("Valid values for f5xc_tf_params_action: apply, plan")
  }
}

variable "f5xc_tf_wait_for_action" {
  type    = bool
  default = true
}

variable "custom_tags" {
  description = "Custom tags to set on resources"
  type        = map(string)
  default     = {}
}