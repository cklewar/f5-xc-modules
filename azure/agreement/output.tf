output "vnet" {
  value = {
    id = var.f5xc_azure_ce_gw_type != "" ? azurerm_marketplace_agreement.f5xc_azure_ce[0].id : null
  }
}