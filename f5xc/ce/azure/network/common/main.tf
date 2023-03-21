resource "azurerm_virtual_network" "vnet" {
  count               = var.azurerm_existing_virtual_network_name != "" ? 0 : 1
  name                = format("%s-vnet", "")
  location            = var.f5xc_azure_region
  address_space       = var.azurerm_vnet_address_space
  resource_group_name = var.azurerm_resource_group_name
  tags                = var.common_tags
}

module "sg_slo" {
  source                       = "../../../../../azure/security_group"
  azure_linux_security_rules   = []
  azure_region                 = var.f5xc_azure_region
  azure_resource_group_name    = var.azurerm_resource_group_name
  azure_security_group_name    = format("%s-%s", "", "")
  azurerm_network_interface_id = var.azurerm_network_interface_slo_id
}

module "sg_sli" {
  source                       = "../../../../../azure/security_group"
  azure_linux_security_rules   = []
  azure_region                 = var.f5xc_azure_region
  azure_resource_group_name    = var.azurerm_resource_group_name
  azure_security_group_name    = format("%s-%s", "", "")
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