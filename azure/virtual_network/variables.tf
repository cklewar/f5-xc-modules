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

variable "azure_vnet_dns_servers" {
  type    = list(string)
  default = []
}

variable "azure_vnet_subnets" {
  type = list(object({
    name           = string
    address_prefix = string
    security_group = optional(string)
  }))
  default = []
}

variable "azure_vnet_static_routes" {
  type = list(object({
    name           = string
    address_prefix = string
    next_hop_type  = string
  }))
  default = []
}

variable "custom_tags" {
  description = "Custom tags to set on resources"
  type        = map(string)
  default     = {}
}