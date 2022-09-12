output "vnet" {
  value = {
    id = var.f5xc_azure_ce_gw_type != "" && length(azurerm_marketplace_agreement) > 0 ? azurerm_marketplace_agreement.f5xc_azure_ce[0].id : azurerm_marketplace_agreement.generic[0].id
  }
}