resource "azurerm_public_ip" "ip" {
  for_each            = {for interface in var.azure_network_interfaces : interface.name => interface if interface.ip_configuration.create_public_ip_address}
  sku                 = var.azure_virtual_machine_sku
  tags                = var.custom_tags
  name = format("%s-public-ip", each.value.name)
  zones = [var.azure_zone]
  location            = var.azure_region
  allocation_method   = var.azure_virtual_machine_allocation_method
  resource_group_name = var.azure_resource_group_name
}

resource "azurerm_network_interface" "network_interface" {
  count = length(var.azure_network_interfaces)
  tags                = var.azure_network_interfaces[count.index].tags
  name                = var.azure_network_interfaces[count.index].name
  location            = var.azure_region
  resource_group_name = var.azure_resource_group_name

  ip_configuration {
    name = format("%s-ip-cfg", var.azure_network_interfaces[count.index].name)
    subnet_id = var.azure_network_interfaces[count.index].ip_configuration.subnet_id
    # private_ip_address            = var.azure_network_interfaces[count.index].ip_configuration.private_ip_address_allocation == "Static" ? var.azure_network_interfaces[count.index].ip_configuration.private_ip_address : null
    private_ip_address            = "192.168.168.7"
    public_ip_address_id          = contains(keys(azurerm_public_ip.ip), var.azure_network_interfaces[count.index].name) ? azurerm_public_ip.ip[var.azure_network_interfaces[count.index].name].id : null
    private_ip_address_allocation = var.azure_network_interfaces[count.index].ip_configuration.private_ip_address_allocation
  }
}

data "cloudinit_config" "config" {
  gzip          = false
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content      = local.cloud_init_content
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.azure_virtual_machine_name
  zone                            = var.azure_zone
  size                            = var.azure_virtual_machine_size
  tags                            = var.custom_tags
  location                        = var.azure_region
  user_data                       = data.cloudinit_config.config.rendered
  custom_data                     = var.azure_linux_virtual_machine_custom_data != "" ? base64encode(var.azure_linux_virtual_machine_custom_data) : null
  computer_name                   = var.azure_virtual_machine_name
  admin_username                  = var.azure_linux_virtual_machine_admin_username
  admin_password                  = var.azure_linux_virtual_machine_disable_password_authentication ? null : var.azure_linux_virtual_machine_admin_password
  resource_group_name             = var.azure_resource_group_name
  network_interface_ids           = [for interface in azurerm_network_interface.network_interface : interface.id]
  disable_password_authentication = var.azure_linux_virtual_machine_disable_password_authentication

  os_disk {
    name                 = var.azure_virtual_machine_name
    caching              = var.azure_linux_virtual_machine_os_disk_caching
    storage_account_type = var.azure_linux_virtual_machine_os_disk_storage_account_type
  }

  source_image_reference {
    sku       = var.azure_linux_virtual_machine_source_image_reference_sku
    offer     = var.azure_linux_virtual_machine_source_image_reference_offer
    version   = var.azure_linux_virtual_machine_source_image_reference_version
    publisher = var.azure_linux_virtual_machine_source_image_reference_publisher
  }

  admin_ssh_key {
    username   = var.azure_linux_virtual_machine_admin_username
    public_key = var.ssh_public_key
  }
}