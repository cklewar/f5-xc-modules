output "common" {
  value = {
    vnet          = length(azurerm_virtual_network.vnet) > 0 ? azurerm_virtual_network.vnet[0] : null
    sg_slo        = module.sg_slo.security_group
    sg_sli        = var.is_multi_nic ? module.sg_sli.security_group[0] : null
    existing_vnet = var.azurerm_existing_vnet_name != "" ? data.azurerm_virtual_network.existing_vnet : null
  }
}