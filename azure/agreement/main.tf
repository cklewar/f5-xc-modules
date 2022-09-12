resource "azurerm_marketplace_agreement" "single_nic" {
  count     = f5xc_default_azure_marketplace_agreement == true ? 1 : 0
  publisher = var.f5xc_azure_marketplace_agreement_publisher
  offer     = var.f5xc_azure_marketplace_agreement_offers[var.f5xc_azure_ce_gw_type]
  plan      = var.f5xc_azure_marketplace_agreement_plans[var.f5xc_azure_ce_gw_type]
}

resource "azurerm_marketplace_agreement" "multi_nic" {
  count     = f5xc_default_azure_marketplace_agreement == true ? 1 : 0
  publisher = var.f5xc_azure_marketplace_agreement_publisher
  offer     = var.f5xc_azure_marketplace_agreement_offers[var.f5xc_azure_ce_gw_type]
  plan      = var.f5xc_azure_marketplace_agreement_plans[var.f5xc_azure_ce_gw_type]
}

resource "azurerm_marketplace_agreement" "app_stack" {
  count     = f5xc_default_azure_marketplace_agreement == true ? 1 : 0
  publisher = var.f5xc_azure_marketplace_agreement_publisher
  offer     = var.f5xc_azure_marketplace_agreement_offers[var.f5xc_azure_ce_gw_type]
  plan      = var.f5xc_azure_marketplace_agreement_plans[var.f5xc_azure_ce_gw_type]
}

resource "azurerm_marketplace_agreement" "generic" {
  count     = f5xc_default_azure_marketplace_agreement == false ? 1 : 0
  publisher = var.f5xc_azure_marketplace_agreement_publisher
  offer     = var.f5xc_azure_marketplace_agreement_offers[var.f5xc_azure_ce_gw_type]
  plan      = var.f5xc_azure_marketplace_agreement_plans[var.f5xc_azure_ce_gw_type]
}