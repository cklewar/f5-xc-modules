variable "azure_virtual_machine_name" {
  type = string
}

variable "azure_virtual_machine_size" {
  type    = string
  default = "Standard_DS1_v2"
}

variable "azure_zone" {
  type    = number
  default = 1
}

variable "azure_linux_virtual_machine_admin_username" {
  type    = string
  default = "azueruser"
}

variable "azure_vnet_subnet_id" {
  type = string
}

variable "azure_region" {
  type = string
}

variable "azure_resource_group_name" {
  type = string
}

variable "azure_virtual_machine_allocation_method" {
  type    = string
  default = "Static"
}

variable "azure_virtual_machine_sku" {
  type    = string
  default = "Standard"
}

variable "azure_network_interface_name" {
  type = string
}

variable "azure_network_interface_ip_cfg_name" {
  type    = string
  default = "internal"
}

variable "azure_linux_virtual_machine_source_image_reference_publisher" {
  type    = string
  default = "Canonical"
}

variable "azure_linux_virtual_machine_source_image_reference_offer" {
  type    = string
  default = "UbuntuServer"
}

variable "azure_linux_virtual_machine_source_image_reference_sku" {
  type    = string
  default = "18.04-LTS"
}

variable "azure_linux_virtual_machine_source_image_reference_version" {
  type    = string
  default = "latest"
}

variable "azure_network_interface_private_ip_address_allocation" {
  type    = string
  default = "Dynamic"
}

variable "azure_linux_virtual_machine_disable_password_authentication" {
  type    = bool
  default = true
}

variable "azure_linux_virtual_machine_os_disk_caching" {
  type    = string
  default = "ReadWrite"
}

variable "azure_linux_virtual_machine_os_disk_storage_account_type" {
  type    = string
  default = "Premium_LRS"
}

variable "azure_linux_virtual_machine_custom_data" {
  type    = string
  default = ""
}

variable "public_ssh_key" {
  type = string
}
