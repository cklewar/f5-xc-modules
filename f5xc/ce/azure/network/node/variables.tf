variable "has_public_ip" {
  type = bool
}

variable "is_multi_nic" {
  type = bool
}

variable "f5xc_node_name" {
  type = string
}

variable "f5xc_ce_public_ip_id" {
  type = string
}

variable "f5xc_azure_region" {
  type = string
}

variable "azurerm_resource_group_name" {
  type = string
}

variable "azurerm_vnet_name" {
  type = string
}

variable "subnet_slo_id" {
  type = string
}

variable "subnet_sli_id" {
  type = string
}

variable "azurerm_public_ip_allocation_method" {
  type    = string
  default = "Static"
}

variable "azurerm_private_ip_address_allocation" {
  type    = string
  default = "dynamic"
}

variable "azurerm_security_group_slo_id" {
  type = string
}

variable "azurerm_security_group_sli_id" {
  type = string
}

variable "enable_ip_forwarding" {
  type    = bool
  default = true
}

variable "enable_accelerated_networking" {
  type    = bool
  default = true
}