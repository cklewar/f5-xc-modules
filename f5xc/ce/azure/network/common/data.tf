data "azurerm_virtual_network" "existing_vnet" {
  count               = var.azurerm_existing_virtual_network_name != "" ? 1 : 0
  name                = var.azurerm_existing_virtual_network_name
  resource_group_name = var.azurerm_resource_group_name
}