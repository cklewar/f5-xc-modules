output "resource_group" {
  value = {
    "id"       = azurerm_resource_group.rg.id
    "name"     = azurerm_resource_group.rg.name
    "location" = azurerm_resource_group.rg.location
  }
}