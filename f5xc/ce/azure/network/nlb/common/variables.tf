variable "is_multi_nic" {
  type = bool
}

variable "azurerm_resource_group_name" {
  type = string
}

variable "f5xc_cluster_name" {
  type = string
}

variable "f5xc_azure_region" {
  type = string
}

variable "f5xc_ce_k8s_api_server_port" {
  type    = string
  default = "6443"
}

variable "azurerm_lb_frontend_ip_configuration" {
  type = list(object({
    name      = string
    subnet_id = string
  }))
}

variable "f5xc_site_set_vip_info_namespace" {
  type = string
}

variable "f5xc_site_set_vip_info_site_type" {
  type    = string
  default = "azure_vnet_site"
}

variable "f5xc_azure_az_nodes" {
  type = map(map(string))
}

/*variable "f5xc_site_set_vip_info_vip_params_per_az" {
  type = list(object({
    az      = string
    slo_vip = string
    sli_vip = optional(string)
  }))
}*/