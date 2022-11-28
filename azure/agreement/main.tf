resource "azurerm_marketplace_agreement" "f5xc_azure_ce" {
  count     = var.f5xc_azure_ce_gw_type != "" ? 1 : 0
  publisher = var.f5xc_azure_marketplace_agreement_publisher
  offer     = var.f5xc_azure_marketplace_agreement_offers[var.f5xc_azure_ce_gw_type]
  plan      = var.f5xc_azure_marketplace_agreement_plans[var.f5xc_azure_ce_gw_type]
}

resource "azurerm_marketplace_agreement" "generic" {
  count     = var.f5xc_azure_ce_gw_type == "" ? 1 : 0
  publisher = var.f5xc_azure_marketplace_agreement_publisher
  offer     = var.azure_marketplace_agreement_offer_generic
  plan      = var.azure_marketplace_agreement_plan_generic
}