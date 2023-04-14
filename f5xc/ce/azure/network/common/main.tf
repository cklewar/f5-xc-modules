resource "azurerm_virtual_network" "vnet" {
  count               = var.azurerm_existing_virtual_network_name != "" ? 0 : 1
  name                = format("%s-vnet", var.f5xc_cluster_name)
  location            = var.f5xc_azure_region
  address_space       = var.azurerm_vnet_address_space
  resource_group_name = var.azurerm_resource_group_name
  tags                = var.common_tags
}

module "sg_slo" {
  source                                      = "../../../../../azure/security_group"
  custom_tags                                 = var.common_tags
  azure_region                                = var.f5xc_azure_region
  azure_resource_group_name                   = var.azurerm_resource_group_name
  azure_security_group_name                   = format("%s-slo", var.f5xc_cluster_name)
  azure_linux_security_rules                  = var.azure_linux_security_slo_rules
  create_interface_security_group_association = false
}

module "sg_sli" {
  count                                       = var.is_multi_nic ? 1 : 0
  source                                      = "../../../../../azure/security_group"
  custom_tags                                 = var.common_tags
  azure_region                                = var.f5xc_azure_region
  azure_resource_group_name                   = var.azurerm_resource_group_name
  azure_security_group_name                   = format("%s-sli", var.f5xc_cluster_name)
  azure_linux_security_rules                  = var.azure_linux_security_sli_rules
  create_interface_security_group_association = false
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