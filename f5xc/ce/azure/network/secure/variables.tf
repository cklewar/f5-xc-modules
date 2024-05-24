variable "f5xc_cluster_name" {
  type = string
}

variable "azurerm_resource_group_name" {
  type = string
}

variable "azurerm_region" {
  type = string
}

variable "azurerm_zones" {
  type = list(string)
}

variable "azurerm_nat_gateway_subnet_ids" {
  type = list(string)
}

variable "azurerm_public_ip_prefix_prefix_length" {
  type    = number
  default = 31
}

variable "azurerm_nat_gateway_idle_timeout_in_minutes" {
  type    = number
  default = 10
}