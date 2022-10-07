output "security_group" {
  value = {
    "id"            = azurerm_network_security_group.sg.id
    "name"          = azurerm_network_security_group.sg.name
    "security_rule" = azurerm_network_security_group.sg.security_rule
  }
}