output "resource_group" {
  value = {
    "name"     = azurerm_resource_group.rg.name
    "id"       = azurerm_resource_group.rg.id
    "location" = azurerm_resource_group.rg.location
  }
}