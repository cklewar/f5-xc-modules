variable "is_multi_nic" {
  type = bool
}

variable "azurerm_resource_group_name" {
  type = string
}

variable "azurerm_region" {
  type = string
}

variable "f5xc_ce_slo_probe_port" {
  type    = number
  default = 9505
}

variable "f5xc_ce_sli_probe_port" {
  type    = number
  default = 65450
}

variable "azurerm_lb_frontend_ip_configuration" {
  type = list(object({
    name      = string
    subnet_id = string
  }))
}

variable "azurerm_availability_set_id" {
  type    = string
}

variable "f5xc_cluster_name" {
  type = string
}

variable "f5xc_site_set_vip_info_namespace" {
  type = string
}

variable "f5xc_site_set_vip_info_site_type" {
  type    = string
  default = "azure_vnet_site"
}

variable "f5xc_cluster_nodes" {
  type = map(map(string))
}

/*variable "f5xc_site_set_vip_info_vip_params_per_az" {
  type = list(object({
    az      = string
    slo_vip = string
    sli_vip = optional(string)
  }))
}*/