output "ce" {
  value = {
    slo = azurerm_network_interface.slo
    sli = var.is_multi_nic ? azurerm_network_interface.sli : null
  }
}