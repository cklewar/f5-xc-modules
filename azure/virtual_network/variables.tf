variable "azure_vnet_name" {
  type = string
}

variable "azure_region" {
  type = string
}

variable "azure_vnet_resource_group_name" {
  type = string
}

variable "azure_vnet_primary_ipv4" {
  type = string
}

variable "azure_subscription_id" {
  type    = string
  default = ""
}

variable "azure_client_id" {
  type    = string
  default = ""
}

variable "azure_client_secret" {
  type    = string
  default = ""
}

variable "azure_tenant_id" {
  type    = string
  default = ""
}