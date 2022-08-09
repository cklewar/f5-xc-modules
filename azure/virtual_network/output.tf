output "vnet" {
  value = {
    "name"          = azurerm_virtual_network.vnet.name
    "address_space" = azurerm_virtual_network.vnet.address_space
  }
}