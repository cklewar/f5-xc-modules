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

variable "f5xc_azure_site_name" {
  type = string

  validation {
    condition     = length(var.f5xc_azure_site_name) <= 22
    error_message = "f5xc_azure_site_name must contain no more than 22 symbols."
  }
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
  default = "Standard_D3_v2"
}

variable "f5xc_azure_vnet_primary_ipv4" {
  type    = string
  default = ""
}

variable "f5xc_azure_az_nodes" {
  type = map(map(string))
}

variable "f5xc_azure_hub_spoke_vnets" {
  type = list(object({
    resource_group = string
    vnet_name      = string
    auto           = bool
    manual         = bool
    labels         = map(string)
  }))
  default = []
}

variable "f5xc_azure_express_route_sku_standard" {
  type    = bool
  default = false
}

variable "f5xc_azure_express_route_sku_high_perf" {
  type    = bool
  default = false
}

variable "f5xc_azure_express_route_sku_ergw1az" {
  type    = bool
  default = false
}

variable "f5xc_azure_express_route_sku_ergw2az" {
  type    = bool
  default = false
}

variable "f5xc_azure_express_route_connections" {
  type = list(object({
    name        = string
    description = string
    circuit_id  = string
    weight      = number
  }))
  default = []
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

variable "f5xc_azure_site_kind" {
  type    = string
  default = "azure_vnet_site"
}

variable "f5xc_azure_ce_disk_size" {
  type    = string
  default = "80"
}

variable "ssh_public_key" {
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

variable "f5xc_azure_vnet_site_resource_group" {
  type = string
}

variable "f5xc_azure_new_vnet_name" {
  type    = string
  default = ""
}

variable "f5xc_azure_existing_vnet_resource_group" {
  type    = string
  default = ""
}

variable "f5xc_azure_existing_vnet_name" {
  type    = string
  default = ""
}

variable "f5xc_azure_vnet_static_routes" {
  type = list(object({
    name             = string
    address_prefix   = string
    route_table_name = string
    next_hop_type    = string
  }))
  default = []
}

variable "f5xc_nic_type_single_nic" {
  type    = string
  default = "single_nic"
}

variable "f5xc_nic_type_multi_nic" {
  type    = string
  default = "multi_nic"
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

variable "f5xc_cloud_site_labels_ignore_on_delete" {
  type    = bool
  default = true
}

variable "custom_tags" {
  description = "Custom tags to set on resources"
  type        = map(string)
  default     = {}
}

variable "f5xc_azure_express_route_server_subnet" {
  type        = string
  default     = ""
}

variable "f5xc_azure_express_gateway_subnet" {
  type        = string
  default     = ""
}

variable "custom_labels" {
  description = "Custom labels to set on resources"
  type        = map(string)
  default     = {}
}
