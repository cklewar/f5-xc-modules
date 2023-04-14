resource "azurerm_network_interface_backend_address_pool_association" "slo" {
  network_interface_id    = var.azurerm_network_interface_slo_id
  ip_configuration_name   = format("%s-ip-cfg", var.f5xc_node_name)
  backend_address_pool_id = var.azurerm_backend_address_pool_id_slo
}

resource "azurerm_network_interface_backend_address_pool_association" "sli" {
  count                   = var.is_multi_nic ? 1 : 0
  network_interface_id    = var.azurerm_network_interface_sli_id
  ip_configuration_name   = format("%s-ip-cfg", var.f5xc_node_name)
  backend_address_pool_id = var.azurerm_backend_address_pool_id_slo
}