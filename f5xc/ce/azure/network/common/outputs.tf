output "common" {
  value = {
    vnet             = length(azurerm_virtual_network.vnet) > 0 ? azurerm_virtual_network.vnet[0] : null
    sg_slo           = module.sg_slo.security_group
    sg_sli           = var.is_multi_nic ? module.sg_sli.security_group[0] : null
    sg_slo_secure_ce = var.f5xc_is_secure_cloud_ce ? module.sg_slo_secure_ce[0].security_group : null
    sg_sli_secure_ce = var.is_multi_nic && var.f5xc_is_secure_cloud_ce ? module.sg_sli_secure_ce[0].security_group : null
    existing_vnet    = var.azurerm_existing_vnet_name != "" ? data.azurerm_virtual_network.existing_vnet : null
  }
}