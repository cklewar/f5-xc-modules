data "azurerm_virtual_network" "existing_vnet" {
  name                = var.azurerm_existing_virtual_network_name
  resource_group_name = var.azurerm_resource_group_name
}