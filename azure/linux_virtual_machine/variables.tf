variable "azure_virtual_machine_name" {
  type = string
}

variable "azure_virtual_machine_size" {
  type    = string
  default = "Standard_DS1_v2"
}

variable "azure_zone" {
  type = number
}

variable "azure_linux_virtual_machine_admin_username" {
  type    = string
  default = "ubuntu"
}

variable "azure_linux_virtual_machine_admin_password" {
  type    = string
  default = ""
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

variable "azure_linux_virtual_machine_source_image_reference_publisher" {
  type    = string
  default = "Canonical"
}

variable "azure_linux_virtual_machine_source_image_reference_offer" {
  type    = string
  default = "0001-com-ubuntu-server-jammy"
}

variable "azure_linux_virtual_machine_source_image_reference_sku" {
  type    = string
  default = "22_04-lts"
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
  default = "Standard_LRS"
}

variable "azure_linux_virtual_machine_custom_data" {
  type    = string
  default = ""
}

variable "azure_virtual_machine_cloud_init_template" {
  type    = string
  default = ""
}

variable "azure_virtual_machine_cloud_init_template_data" {
  type = map(string)
  default = {}
}

variable "azure_network_interfaces" {
  type = list(object({
    name = string
    ip_configuration = object({
      subnet_id                     = string
      private_ip_address            = optional(string)
      create_public_ip_address      = bool
      private_ip_address_allocation = string
    })
    tags = optional(map(string))
  }))
}

variable "ssh_public_key" {
  type = string
}

variable "create_public_ip" {
  type    = bool
  default = false
}

variable "custom_tags" {
  description = "Custom tags to set on resources"
  type = map(string)
  default = {}
}

variable "template_input_dir_path" {
  type    = string
  default = ""
}