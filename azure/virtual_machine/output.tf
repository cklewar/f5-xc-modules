output "virtual_machine" {
  value = {
    "name"       = azurerm_linux_virtual_machine.vm.name
    "id"         = azurerm_linux_virtual_machine.vm.id
    "public_ip"  = azurerm_linux_virtual_machine.vm.public_ip_address
    "private_ip" = azurerm_linux_virtual_machine.vm.private_ip_address
  }
}