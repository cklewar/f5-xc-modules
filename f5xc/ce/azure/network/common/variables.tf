variable "is_multi_nic" {
  type = bool
}

variable "is_multi_node" {
  type = bool
}

variable "common_tags" {
  type = map(string)
}

variable "azurerm_vnet_address_space" {
  type = list(string)
}

variable "azurerm_existing_virtual_network_name" {
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

variable "f5xc_site_set_vip_info_namespace" {
  type = string
}

variable "f5xc_site_set_vip_info_site_type" {
  type    = string
  default = "azure_vnet_site"
}

variable "vip_params_per_az" {
  type = list(object({
    az      = string
    slo_vip = string
    sli_vip = string
  }))
}

variable "azurerm_frontend_ip_configuration" {
  type = list(object({
    name      = string
    subnet_id = string
  }))
}

variable "azurerm_resource_group_name" {
  type = string
}

variable "azurerm_network_interface_slo_id" {
  type = string
}

variable "azurerm_network_interface_sli_id" {
  type = string
}

variable "azure_linux_security_slo_rules" {
  type = list(object({
    name                       = string
    access                     = string
    priority                   = number
    protocol                   = string
    direction                  = string
    source_port_range          = string
    source_address_prefix      = optional(string)
    destination_port_range     = string
    destination_address_prefix = optional(string)
  }))
}

variable "azure_linux_security_sli_rules" {
  type = list(object({
    name                       = string
    access                     = string
    priority                   = number
    protocol                   = string
    direction                  = string
    source_port_range          = string
    source_address_prefix      = optional(string)
    destination_port_range     = string
    destination_address_prefix = optional(string)
  }))
}