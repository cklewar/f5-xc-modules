output "ce" {
  value = {
    id                    = azurerm_linux_virtual_machine.instance.id
    name                  = azurerm_linux_virtual_machine.instance.name
    tags                  = azurerm_linux_virtual_machine.instance.tags
    resource_group_name   = azurerm_linux_virtual_machine.instance.resource_group_name
    network_interface_ids = azurerm_linux_virtual_machine.instance.network_interface_ids
  }
}
