resource "azurerm_virtual_network" "vnet" {
  count               = var.azurerm_existing_virtual_network_name != "" ? 1 : 0
  name                = format("%s-vnet", "")
  location            = var.f5xc_azure_region
  address_space       = var.azurerm_vnet_address_space
  resource_group_name = var.azurerm_resource_group_name
  tags                = var.common_tags
}

module "sg_slo" {
  source                       = "../../../../../azure/security_group"
  custom_tags                  = var.common_tags
  azure_region                 = var.f5xc_azure_region
  azure_linux_security_rules   = var.azure_linux_security_slo_rules
  azure_resource_group_name    = var.azurerm_resource_group_name
  azure_security_group_name    = format("%s-slo", var.f5xc_cluster_name)
  azurerm_network_interface_id = var.azurerm_network_interface_slo_id
}

module "sg_sli" {
  count                        = var.is_multi_nic ? 1 : 0
  source                       = "../../../../../azure/security_group"
  custom_tags                  = var.common_tags
  azure_region                 = var.f5xc_azure_region
  azure_linux_security_rules   = var.azure_linux_security_sli_rules
  azure_resource_group_name    = var.azurerm_resource_group_name
  azure_security_group_name    = format("%s-sli", var.f5xc_cluster_name)
  azurerm_network_interface_id = var.azurerm_network_interface_sli_id
}

/*resource "azurerm_network_security_rule" "slo_ingress" {
  name                        = "all"
  priority                    = 140
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = local.any
  source_port_range           = local.any
  destination_port_range      = local.any
  source_address_prefix       = local.any
  destination_address_prefix  = local.any
  resource_group_name         = var.azurerm_resource_group_name
  network_security_group_name = module.sg_slo.security_group["name"]
}

resource "azurerm_network_security_rule" "slo_egress" {
  name                        = "default"
  priority                    = 140
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = local.any
  source_port_range           = local.any
  destination_port_range      = local.any
  source_address_prefix       = local.any
  destination_address_prefix  = local.any
  resource_group_name         = var.azurerm_resource_group_name
  network_security_group_name = module.sg_slo.security_group["name"]
}

resource "azurerm_network_security_rule" "sli_ingress" {
  count                       = var.is_multi_nic ? 1 : 0
  name                        = "default"
  priority                    = 140
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = local.any
  source_port_range           = local.any
  destination_port_range      = local.any
  source_address_prefix       = local.any
  destination_address_prefix  = local.any
  resource_group_name         = var.azurerm_resource_group_name
  network_security_group_name = module.sg_sli.security_group["name"]
}

resource "azurerm_network_security_rule" "sli_egress" {
  count                       = var.is_multi_nic ? 1 : 0
  name                        = "default"
  priority                    = 140
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = local.any
  source_port_range           = local.any
  destination_port_range      = local.any
  source_address_prefix       = local.any
  destination_address_prefix  = local.any
  resource_group_name         = var.azurerm_resource_group_name
  network_security_group_name = module.sg_sli.security_group["name"]
}*/

resource "azurerm_lb" "lb" {
  name                = format("%s-lb", var.f5xc_cluster_name)
  location            = var.f5xc_azure_region
  resource_group_name = var.azurerm_resource_group_name
  sku                 = "Standard"

  dynamic "frontend_ip_configuration" {
    for_each = var.azurerm_frontend_ip_configuration
    content {
      name      = frontend_ip_configuration.value.name
      subnet_id = frontend_ip_configuration.value.subnet_id
    }
  }
}

resource "azurerm_lb_backend_address_pool" "slo" {
  name                = format("%s-slo-lb-pool", var.f5xc_cluster_name)
  resource_group_name = var.azurerm_resource_group_name
  loadbalancer_id     = azurerm_lb.lb.id
}

resource "azurerm_lb_backend_address_pool" "sli" {
  count               = var.is_multi_node ? 1 : 0
  name                = format("%s-sli-lb-pool", var.f5xc_cluster_name)
  resource_group_name = var.azurerm_resource_group_name
  loadbalancer_id     = azurerm_lb.lb.id
}

resource "azurerm_lb_probe" "probe" {
  name                = format("%s-lb-probe", var.f5xc_cluster_name)
  resource_group_name = var.azurerm_resource_group_name
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "tcp"
  port                = var.f5xc_ce_k8s_api_server_port
}

resource "azurerm_lb_rule" "k8s" {
  name                           = format("%s-lb-rule-k8s", var.f5xc_cluster_name)
  resource_group_name            = var.azurerm_resource_group_name
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = var.f5xc_ce_k8s_api_server_port
  backend_port                   = var.f5xc_ce_k8s_api_server_port
  frontend_ip_configuration_name = "loadbalancer-frontend-slo-ip"
  probe_id                       = azurerm_lb_probe.probe.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.slo.id
}

resource "azurerm_lb_rule" "slo" {
  count                          = var.is_multi_node ? 1 : 0
  name                           = format("%s-slo-lb-rule", var.f5xc_cluster_name)
  resource_group_name            = var.azurerm_resource_group_name
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "loadbalancer-slo-all"
  probe_id                       = azurerm_lb_probe.probe.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.slo.id
}

resource "azurerm_lb_rule" "sli" {
  count                          = var.is_multi_node ? 1 : 0
  name                           = format("%s-sli-lb-rule", var.f5xc_cluster_name)
  resource_group_name            = var.azurerm_resource_group_name
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "loadbalancer-sli-all"
  probe_id                       = azurerm_lb_probe.probe.id
  backend_address_pool_id        = join("", azurerm_lb_backend_address_pool.sli.*.id)
}

resource "volterra_site_set_vip_info" "azure_site" {
  count     = var.is_multi_node ? 1 : 0
  name      = var.f5xc_cluster_name
  namespace = var.f5xc_site_set_vip_info_namespace
  site_type = var.f5xc_site_set_vip_info_site_type

  dynamic "vip_params_per_az" {
    for_each = var.vip_params_per_az
    content {
      az_name     = vip_params_per_az.value.az
      outside_vip = vip_params_per_az.value.slo_vip
      inside_vip  = vip_params_per_az.value.sli_vip
    }
  }
}

