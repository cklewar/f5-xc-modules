output "ce" {
  value = {
    name          = var.f5xc_node_name
    slo           = azurerm_network_interface.slo
    public_ip     = var.has_public_ip ? azurerm_public_ip.ip.0 : null
    slo_subnet    = var.azurerm_existing_subnet_name_slo == null ? azurerm_subnet.slo.0 : data.azurerm_subnet.slo.0
    interface_ids = local.interface_ids
  }
}