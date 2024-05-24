/*resource "azurerm_network_interface_backend_address_pool_association" "slo" {
  network_interface_id    = var.azurerm_network_interface_slo_id
  ip_configuration_name   = format("%s-slo", var.f5xc_node_name)
  backend_address_pool_id = var.azurerm_backend_address_pool_id_slo
}

resource "azurerm_network_interface_backend_address_pool_association" "sli" {
  count                   = var.is_multi_nic ? 1 : 0
  network_interface_id    = var.azurerm_network_interface_sli_id
  ip_configuration_name   = format("%s-sli", var.f5xc_node_name)
  backend_address_pool_id = var.azurerm_backend_address_pool_id_sli
}*/

/*
resource "azurerm_lb_rule" "slo" {
  name                           = format("%s-slo-lb-rule", var.f5xc_node_name)
  probe_id                       = var.azurerm_lb_probe_id_slo
  protocol                       = "All"
  backend_port                   = 0
  frontend_port                  = 0
  loadbalancer_id                = var.azurerm_lb_id
  backend_address_pool_ids       = [var.azurerm_backend_address_pool_id_slo]
  frontend_ip_configuration_name = format("%s-slo", var.f5xc_node_name)
}

resource "azurerm_lb_rule" "sli" {
  count                          = var.is_multi_nic ? 1 : 0
  name                           = format("%s-sli-lb-rule", var.f5xc_node_name)
  probe_id                       = var.azurerm_lb_probe_id_sli
  protocol                       = "All"
  backend_port                   = 0
  frontend_port                  = 0
  loadbalancer_id                = var.azurerm_lb_id
  backend_address_pool_ids       = [var.azurerm_backend_address_pool_id_sli]
  frontend_ip_configuration_name = format("%s-sli", var.f5xc_node_name)
}*/