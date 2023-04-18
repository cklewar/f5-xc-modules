output "ce" {
  value = {
    ip_prefix                = azurerm_public_ip_prefix.nat.ip_prefix
    nat_gateway              = azurerm_nat_gateway.gw
  }
}