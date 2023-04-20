output "common" {
  value = {
    lb                       = azurerm_lb.lb
    azurerm_lb_rule_slo      = azurerm_lb_rule.slo
    azurerm_lb_rule_sli      = azurerm_lb_rule.sli
    azurerm_lb_rule_k8s      = azurerm_lb_rule.k8s
    backend_address_pool_slo = azurerm_lb_backend_address_pool.slo
    backend_address_pool_sli = azurerm_lb_backend_address_pool.sli
  }
}