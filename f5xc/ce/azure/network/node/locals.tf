locals {
  interface_ids = [azurerm_network_interface.slo.id, length(azurerm_network_interface.sli) > 0 ? azurerm_network_interface.sli[0].id : ""]
}