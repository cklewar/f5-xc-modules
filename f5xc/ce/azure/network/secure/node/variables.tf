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

variable "f5xc_secure_ce_zones" {
  type    = list(string)
  default = ["1"]
}

variable "azurerm_nat_gateway_subnet_id" {
  type = string
}

variable "azurerm_public_ip_prefix_prefix_length" {
  type    = number
  default = 31
}

variable "azurerm_nat_gateway_idle_timeout_in_minutes" {
  type    = number
  default = 10
}