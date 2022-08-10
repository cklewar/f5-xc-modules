output "vnet" {
  value = {
    "name"          = azurerm_virtual_network.vnet.name
    "id"            = azurerm_virtual_network.vnet.id
    "address_space" = azurerm_virtual_network.vnet.address_space
  }
}