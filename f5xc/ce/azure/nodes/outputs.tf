output "ce" {
  value = {
    id                           = azurerm_virtual_machine.instance.id
    name                         = azurerm_virtual_machine.instance.name
    tags                         = azurerm_virtual_machine.instance.tags
    resource_group_name          = azurerm_virtual_machine.instance.resource_group_name
    network_interface_ids        = azurerm_virtual_machine.instance.network_interface_ids
    primary_network_interface_id = azurerm_virtual_machine.instance.primary_network_interface_id
  }
}
