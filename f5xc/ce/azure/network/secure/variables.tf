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

variable "azurerm_nat_gateway_subnet_id" {
  type = string
}

variable "azurerm_network_interface_slo_id" {
  type = string
}

variable "azurerm_network_interface_sli_id" {
  type = string
}

variable "azurerm_security_group_secure_ce_slo_id" {
  type = string
}

variable "azurerm_security_group_secure_ce_sli_id" {
  type = string
}