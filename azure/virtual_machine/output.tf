output "output" {
  value = {
    "azure_vm_public_ip"   = azurerm_linux_virtual_machine.vm.public_ip_address
    "azure_vm_private_ip"  = azurerm_linux_virtual_machine.vm.private_ip_address
  }
}