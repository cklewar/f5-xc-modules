output "virtual_machine" {
  value = {
    id                    = azurerm_linux_virtual_machine.vm.id
    name                  = azurerm_linux_virtual_machine.vm.name
    public_ip             = azurerm_linux_virtual_machine.vm.public_ip_address
    private_ip            = azurerm_linux_virtual_machine.vm.private_ip_address
    custom_data           = azurerm_linux_virtual_machine.vm.custom_data
    admin_ssh_key         = azurerm_linux_virtual_machine.vm.admin_ssh_key
    admin_username        = azurerm_linux_virtual_machine.vm.admin_username
    network_interfaces    = [for interface in azurerm_network_interface.network_interface : interface]
    resource_group_name   = azurerm_linux_virtual_machine.vm.resource_group_name
    network_interface_ids = azurerm_linux_virtual_machine.vm.network_interface_ids
  }
}