output "vnet" {
  value = {
    id = var.f5xc_default_azure_marketplace_agreement == true ? azurerm_marketplace_agreement.f5xc_azure_ce[0].id : azurerm_marketplace_agreement.generic[0].id
  }
}