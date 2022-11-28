output "vnet" {
  value = {
    "id"                  = azurerm_virtual_network.vnet.id
    "name"                = azurerm_virtual_network.vnet.name
    "subnet"              = azurerm_virtual_network.vnet.subnet
    "edge_zone"           = azurerm_virtual_network.vnet.edge_zone
    "bgp_community"       = azurerm_virtual_network.vnet.bgp_community
    "address_space"       = azurerm_virtual_network.vnet.address_space
    "resource_group_name" = azurerm_virtual_network.vnet.resource_group_name
  }
}