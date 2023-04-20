variable "owner_tag" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "ssh_public_key" {
  type = string
}

variable "azurerm_instance_network_interface_ids" {
  type = list(string)
}

variable "azurerm_primary_network_interface_id" {
  type = string
}

variable "azurerm_instance_delete_os_disk_on_termination" {
  type    = bool
  default = true
}

variable "azurerm_instance_delete_data_disks_on_termination" {
  type    = bool
  default = true
}

variable "azurerm_availability_set_id" {
  type = string
}

variable "azurerm_instance_vm_size" {
  type = string
}

variable "azurerm_marketplace_publisher" {
  type = string
}

variable "azurerm_marketplace_offer" {
  type = string
}

variable "azurerm_marketplace_plan" {
  type = string
}

variable "azurerm_marketplace_version" {
  type    = string
  default = "latest"
}

variable "azurerm_instance_disk_size" {
  type = number
}

variable "azurerm_instance_admin_username" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_registration_wait_time" {
  type = number
}

variable "f5xc_registration_retry" {
  type = number
}

variable "f5xc_cluster_name" {
  type = string
}

variable "f5xc_cluster_size" {
  type = number
  validation {
    condition     = var.f5xc_cluster_size == 1 || var.f5xc_cluster_size == 3
    error_message = format("Valid values for f5xc_cluster_size: 1 or 3")
  }
}

variable "f5xc_node_name" {
  type = string
}

variable "f5xc_instance_config" {
  type = string
}

variable "f5xc_azure_region" {
  type = string
}

variable "azurerm_resource_group_name" {
  type = string
}