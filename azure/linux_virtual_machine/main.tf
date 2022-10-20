/*resource "azurerm_public_ip" "ip" {
  count               = var.create_public_ip == true ? 1 : 0
  name                = var.azure_virtual_machine_name
  resource_group_name = var.azure_resource_group_name
  location            = var.azure_region
  zones               = var.azure_zones
  allocation_method   = var.azure_virtual_machine_allocation_method
  sku                 = var.azure_virtual_machine_sku
  tags                = var.custom_tags
}*/

resource "azurerm_public_ip" "ip" {
  # for_each            = [for interface in var.azurerm_network_interfaces : interface if interface.ip_configuration.create_public_ip_address]
  count               = length(var.azurerm_network_interfaces) ? var.azurerm_network_interfaces[count.index].ip_configuration.create_public_ip_address : 0
  # name                = format("%s-public-ip", each.value.name)
  name                = format("%s-public-ip", var.azurerm_network_interfaces[count.index].name)
  resource_group_name = var.azure_resource_group_name
  location            = var.azure_region
  zones               = var.azure_zones
  allocation_method   = var.azure_virtual_machine_allocation_method
  sku                 = var.azure_virtual_machine_sku
  tags                = var.custom_tags
}

resource "azurerm_network_interface" "network_interface" {
  # for_each            = [for idx, interface in var.azurerm_network_interfaces : interface]
  count               = length(var.azurerm_network_interfaces)
  # name                = each.value.name
  name                = var.azurerm_network_interfaces[count.index].name
  location            = var.azure_region
  resource_group_name = var.azure_resource_group_name
  # tags                = each.value.tags
  tags                = var.azurerm_network_interfaces[count.index].tags

  /*
  variable "azurerm_network_interfaces" {
  type = list(object({
    name             = string
    ip_configuration = object({
      subnet_id                     = string
      create_public_ip_address      = bool
      private_ip_address_allocation = string
    })
    tags = optional(map(string))
  }))
  }*/

  dynamic "ip_configuration" {
    # for_each = each.value.ip_configuration
    for_each = var.azurerm_network_interfaces[count.index].ip_configuration
    content {
      name                          = format("%s-ip-cfg", var.azurerm_network_interfaces[count.index].name)
      subnet_id                     = ip_configuration.value.subnet_id
      public_ip_address_id          = element(azurerm_public_ip.ip.id, count.index)
      private_ip_address_allocation = ip_configuration.value.ip_configuration
    }
  }

  /*ip_configuration {
    name                          = var.azure_network_interface_ip_cfg_name
    subnet_id                     = var.azure_vnet_subnet_id
    public_ip_address_id          = var.create_public_ip == true ? azurerm_public_ip.ip[0].id : null
    private_ip_address_allocation = var.azure_network_interface_private_ip_address_allocation
  }*/
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.azure_virtual_machine_name
  location              = var.azure_region
  zone                  = var.azure_zone
  size                  = var.azure_virtual_machine_size
  resource_group_name   = var.azure_resource_group_name
  # network_interface_ids = [azurerm_network_interface.network_interface.id]
  network_interface_ids = [for interface in azurerm_network_interface.network_interface : interface.id]

  os_disk {
    name                 = var.azure_virtual_machine_name
    caching              = var.azure_linux_virtual_machine_os_disk_caching
    storage_account_type = var.azure_linux_virtual_machine_os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.azure_linux_virtual_machine_source_image_reference_publisher
    offer     = var.azure_linux_virtual_machine_source_image_reference_offer
    sku       = var.azure_linux_virtual_machine_source_image_reference_sku
    version   = var.azure_linux_virtual_machine_source_image_reference_version
  }

  computer_name                   = var.azure_virtual_machine_name
  admin_username                  = var.azure_linux_virtual_machine_admin_username
  disable_password_authentication = var.azure_linux_virtual_machine_disable_password_authentication

  admin_ssh_key {
    username   = var.azure_linux_virtual_machine_admin_username
    public_key = var.public_ssh_key
  }
  tags        = var.custom_tags
  custom_data = var.azure_linux_virtual_machine_custom_data != "" ? base64encode(var.azure_linux_virtual_machine_custom_data) : null
}