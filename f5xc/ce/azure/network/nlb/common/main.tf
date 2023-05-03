resource "azurerm_lb" "lb" {
  name                = format("%s-lb", var.f5xc_cluster_name)
  location            = var.f5xc_azure_region
  resource_group_name = var.azurerm_resource_group_name

  dynamic "frontend_ip_configuration" {
    for_each = var.azurerm_lb_frontend_ip_configuration
    content {
      name      = frontend_ip_configuration.value.name
      subnet_id = frontend_ip_configuration.value.subnet_id
    }
  }
}

resource "azurerm_lb_backend_address_pool" "slo" {
  name            = format("%s-slo-lb-pool", var.f5xc_cluster_name)
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_backend_address_pool" "sli" {
  name            = format("%s-sli-lb-pool", var.f5xc_cluster_name)
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_probe" "probe" {
  port            = var.f5xc_ce_k8s_api_server_port
  name            = format("%s-lb-probe", var.f5xc_cluster_name)
  protocol        = "Tcp"
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_rule" "k8s" {
  name                           = format("%s-lb-rule-k8s", var.f5xc_cluster_name)
  probe_id                       = azurerm_lb_probe.probe.id
  protocol                       = "Tcp"
  backend_port                   = var.f5xc_ce_k8s_api_server_port
  frontend_port                  = var.f5xc_ce_k8s_api_server_port
  loadbalancer_id                = azurerm_lb.lb.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.slo.id]
  frontend_ip_configuration_name = "loadbalancer-frontend-slo-ip"
}

resource "azurerm_lb_rule" "slo" {
  name                           = format("%s-slo-lb-rule", var.f5xc_cluster_name)
  probe_id                       = azurerm_lb_probe.probe.id
  protocol                       = "All"
  backend_port                   = 0
  frontend_port                  = 0
  loadbalancer_id                = azurerm_lb.lb.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.slo.id]
  frontend_ip_configuration_name = "loadbalancer-slo-all"
}

resource "azurerm_lb_rule" "sli" {
  count                          = var.is_multi_nic ? 1 : 0
  name                           = format("%s-sli-lb-rule", var.f5xc_cluster_name)
  probe_id                       = azurerm_lb_probe.probe.id
  protocol                       = "All"
  backend_port                   = 0
  frontend_port                  = 0
  loadbalancer_id                = azurerm_lb.lb.id
  backend_address_pool_ids       = [join("", azurerm_lb_backend_address_pool.sli.*.id)]
  frontend_ip_configuration_name = "loadbalancer-sli-all"
}

resource "volterra_site_set_vip_info" "site" {
  name      = var.f5xc_cluster_name
  namespace = var.f5xc_site_set_vip_info_namespace
  site_type = var.f5xc_site_set_vip_info_site_type

  dynamic "vip_params_per_az" {
    for_each = local.f5xc_site_set_vip_info_vip_params_per_az
    content {
      az_name     = vip_params_per_az.value.az
      inside_vip  = var.is_multi_nic ? [vip_params_per_az.value.sli_vip] : null
      outside_vip = [vip_params_per_az.value.slo_vip]
    }
  }
}