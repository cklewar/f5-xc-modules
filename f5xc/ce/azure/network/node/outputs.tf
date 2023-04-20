output "ce" {
  value = {
    slo           = azurerm_network_interface.slo
    sli           = var.is_multi_nic ? azurerm_network_interface.sli : null
    rt_sli        = azurerm_route_table.sli
    public_ip     = azurerm_public_ip.ip
    slo_subnet    = azurerm_subnet.slo
    sli_subnet    = var.is_multi_nic ? azurerm_subnet.sli : null
    interface_ids = local.interface_ids
  }
}