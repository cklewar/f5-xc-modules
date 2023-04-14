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
  source                                      = "../../../../../azure/security_group"
  count                                       = var.is_multi_nic ? 1 : 0
  custom_tags                                 = var.common_tags
  azure_region                                = var.f5xc_azure_region
  azure_resource_group_name                   = var.azurerm_resource_group_name
  azure_security_group_name                   = format("%s-sli", var.f5xc_cluster_name)
  azure_linux_security_rules                  = var.azure_linux_security_sli_rules
  create_interface_security_group_association = false
}

module "sg_slo_secure_ce" {
  source                                      = "../../../../../azure/security_group"
  count                                       = var.f5xc_is_secure_cloud_ce ? 1 : 0
  custom_tags                                 = var.common_tags
  azure_region                                = var.f5xc_azure_region
  azure_resource_group_name                   = var.azurerm_resource_group_name
  azure_security_group_name                   = format("%s-slo", var.f5xc_cluster_name)
  azure_linux_security_rules                  = var.azure_linux_security_slo_rules
  create_interface_security_group_association = false
}

module "sg_sli_secure_ce" {
  source                                      = "../../../../../azure/security_group"
  count                                       = var.is_multi_nic && var.f5xc_is_secure_cloud_ce ? 1 : 0
  custom_tags                                 = var.common_tags
  azure_region                                = var.f5xc_azure_region
  azure_resource_group_name                   = var.azurerm_resource_group_name
  azure_security_group_name                   = format("%s-sli", var.f5xc_cluster_name)
  azure_linux_security_rules                  = var.azure_linux_security_sli_rules
  create_interface_security_group_association = false
}