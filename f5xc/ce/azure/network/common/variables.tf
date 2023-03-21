variable "is_multi_nic" {
  type = bool
}

variable "common_tags" {
  type = map(string)
}

variable "f5xc_azure_region" {
  type = string
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