output "node" {
  value = {
    backend_address_pool_association_slo = azurerm_network_interface_backend_address_pool_association.slo
    backend_address_pool_association_sli = azurerm_network_interface_backend_address_pool_association.sli
  }
}