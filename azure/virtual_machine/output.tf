output "virtual_machine" {
  value = {
    "public_ip"  = azurerm_linux_virtual_machine.vm.public_ip_address
    "private_ip" = azurerm_linux_virtual_machine.vm.private_ip_address
  }
}