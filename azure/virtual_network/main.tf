resource "azurerm_virtual_network" "vnet" {
  name                = var.azure_vnet_name
  location            = var.azure_region
  address_space       = [var.azure_vnet_primary_ipv4]
  resource_group_name = var.azure_vnet_resource_group_name
}