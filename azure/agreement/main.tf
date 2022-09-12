resource "azurerm_marketplace_agreement" "f5xc_azure_ce_singel_nic" {
  count     = var.f5xc_default_azure_marketplace_agreement == true ? 1 : 0
  publisher = var.f5xc_azure_marketplace_agreement_publisher
  offer     = var.f5xc_azure_marketplace_agreement_offers["single_nic"]
  plan      = var.f5xc_azure_marketplace_agreement_plans["single_nic"]
}

resource "azurerm_marketplace_agreement" "f5xc_azure_ce_multi_nic" {
  count     = var.f5xc_default_azure_marketplace_agreement == true ? 1 : 0
  publisher = var.f5xc_azure_marketplace_agreement_publisher
  offer     = var.f5xc_azure_marketplace_agreement_offers["multi_nic"]
  plan      = var.f5xc_azure_marketplace_agreement_plans["multi_nic"]
}

resource "azurerm_marketplace_agreement" "f5xc_azure_ce_app_stack" {
  count     = var.f5xc_default_azure_marketplace_agreement == true ? 1 : 0
  publisher = var.f5xc_azure_marketplace_agreement_publisher
  offer     = var.f5xc_azure_marketplace_agreement_offers["app_stack"]
  plan      = var.f5xc_azure_marketplace_agreement_plans["app_stack"]
}

resource "azurerm_marketplace_agreement" "generic" {
  count     = var.f5xc_default_azure_marketplace_agreement == false ? 1 : 0
  publisher = var.f5xc_azure_marketplace_agreement_publisher
  offer     = var.f5xc_azure_marketplace_agreement_offers[var.f5xc_azure_ce_gw_type]
  plan      = var.f5xc_azure_marketplace_agreement_plans[var.f5xc_azure_ce_gw_type]
}