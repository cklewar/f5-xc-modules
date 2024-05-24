resource "azurerm_lb" "lb" {
  sku                 = "Standard"
  name                = format("%s-lb", var.f5xc_cluster_name)
  location            = var.azurerm_region
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
  count           = var.is_multi_nic ? 1 : 0
  name            = format("%s-sli-lb-pool", var.f5xc_cluster_name)
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_probe" "probe_slo" {
  port            = var.f5xc_ce_slo_probe_port
  name            = format("%s-lb-probe-tcp-%s", var.f5xc_cluster_name, var.f5xc_ce_slo_probe_port)
  protocol        = "Tcp"
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_probe" "probe_sli" {
  count           = var.is_multi_nic ? 1 : 0
  port            = var.f5xc_ce_sli_probe_port
  name            = format("%s-lb-probe-tcp-%s", var.f5xc_cluster_name, var.f5xc_ce_sli_probe_port)
  protocol        = "Tcp"
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_rule" "slo" {
  name                           = format("%s-slo-lb-rule", var.f5xc_cluster_name)
  probe_id                       = azurerm_lb_probe.probe_slo.id
  protocol                       = "All"
  backend_port                   = 0
  frontend_port                  = 0
  loadbalancer_id                = azurerm_lb.lb.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.slo.id]
  frontend_ip_configuration_name = format("%s-slo", var.f5xc_cluster_name)
}

resource "azurerm_lb_rule" "sli" {
  count                          = var.is_multi_nic ? 1 : 0
  name                           = format("%s-sli-lb-rule", var.f5xc_cluster_name)
  probe_id                       = azurerm_lb_probe.probe_sli.0.id
  protocol                       = "All"
  backend_port                   = 0
  frontend_port                  = 0
  loadbalancer_id                = azurerm_lb.lb.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.sli.0.id]
  frontend_ip_configuration_name = format("%s-sli", var.f5xc_cluster_name)
}

/*resource "volterra_site_set_vip_info" "site" {
  name      = var.f5xc_cluster_name
  namespace = var.f5xc_site_set_vip_info_namespace
  site_type = var.f5xc_site_set_vip_info_site_type

  dynamic "vip_params_per_az" {
    for_each = local.vip_info_vip_params_per_az
    content {
      az_name     = var.azurerm_availability_set_id != "" ? vip_params_per_az.value.az : "AzureAlternateRegion"
      inside_vip  = var.is_multi_nic ? [vip_params_per_az.value.sli_vip] : null
      outside_vip = [vip_params_per_az.value.slo_vip]
    }
  }
}*/