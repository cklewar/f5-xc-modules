output "common" {
  value = {
    vnet   = var.azurerm_existing_vnet_name != "" ? data.azurerm_virtual_network.existing_vnet.0 : azurerm_virtual_network.vnet.0
    sg_slo = module.sg_slo.security_group
    sg_sli = var.is_multi_nic ? module.sg_sli.0.security_group : null
  }
}