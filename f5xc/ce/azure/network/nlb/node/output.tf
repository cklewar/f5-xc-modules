output "node" {
  value = {
    #lb_rule_slo                          = azurerm_lb_rule.slo
    #lb_rule_sli                          = var.is_multi_nic ? azurerm_lb_rule.sli.0 : null
    #backend_address_pool_association_slo = azurerm_network_interface_backend_address_pool_association.slo
    #backend_address_pool_association_sli = azurerm_network_interface_backend_address_pool_association.sli
  }
}