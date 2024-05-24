output "ce" {
  value = {
    name          = var.f5xc_node_name
    slo           = azurerm_network_interface.slo
    sli           = var.is_multi_nic ? azurerm_network_interface.sli.0 : null
    rt_sli        = var.is_multi_nic ? azurerm_route_table.sli.0 : null
    public_ip     = var.has_public_ip ? azurerm_public_ip.ip.0 : null
    slo_subnet    = var.azurerm_existing_subnet_name_slo == null ? azurerm_subnet.slo.0 : data.azurerm_subnet.slo.0
    sli_subnet    = var.is_multi_nic ? var.azurerm_existing_subnet_name_sli == null ? azurerm_subnet.sli.0 : data.azurerm_subnet.sli.0 : null
    interface_ids = local.interface_ids
  }
}