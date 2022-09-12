output "vnet" {
  value = {
    single_nic_id = azurerm_marketplace_agreement.single_nic.id
    multi_nic_id  = azurerm_marketplace_agreement.multi_nic.id
    app_stack_id  = azurerm_marketplace_agreement.app_stack.id
  }
}