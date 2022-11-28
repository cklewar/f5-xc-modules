variable "azure_region" {
  type = string
}

variable "azure_security_group_name" {
  type = string
}

variable "azure_resource_group_name" {
  type = string
}

variable "azurerm_network_interface_id" {
  type = string
}

variable "azure_linux_security_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = optional(string)
    destination_address_prefix = optional(string)
  }))
}

variable "custom_tags" {
  description = "Custom tags to set on resources"
  type        = map(string)
  default     = {}
}