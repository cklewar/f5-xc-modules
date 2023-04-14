variable "is_multi_nic" {
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

variable "f5xc_is_secure_cloud_ce" {
  type = bool
}

variable "azurerm_resource_group_name" {
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