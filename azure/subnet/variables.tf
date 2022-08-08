variable "azure_subnet_name" {
  type = string
}

variable "azure_vnet_name" {
  type = string
}

variable "azure_subnet_address_prefixes" {
  type = list(string)
}

variable "azure_subnet_resource_group_name" {
  type = string
}