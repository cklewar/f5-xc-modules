resource "azurerm_subnet" "subnet" {
  name                 = var.azure_subnet_name
  virtual_network_name = var.azure_vnet_name
  address_prefixes     = var.azure_subnet_address_prefixes
  resource_group_name  = var.azure_subnet_resource_group_name
}