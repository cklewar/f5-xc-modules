data "azurerm_network_interface" "sli" {
  depends_on          = [module.site_wait_for_online]
  name                = "master-0-sli"
  resource_group_name = volterra_azure_vnet_site.site.resource_group

}

data "azurerm_network_interface" "slo" {
  depends_on          = [module.site_wait_for_online]
  name                = "master-0-slo"
  resource_group_name = volterra_azure_vnet_site.site.resource_group

}

data "azurerm_public_ip" "pib" {
  depends_on          = [module.site_wait_for_online]
  name                = "master-0-public-ip"
  resource_group_name = volterra_azure_vnet_site.site.resource_group
}

data "azurerm_network_interface" "sli" {
  depends_on          = [module.site_wait_for_online]
  count               = length(var.f5xc_azure_az_nodes) >= 2 ? 1 : 0
  name                = "master-1-sli"
  resource_group_name = volterra_azure_vnet_site.site.resource_group

}

data "azurerm_network_interface" "slo" {
  depends_on          = [module.site_wait_for_online]
  count               = length(var.f5xc_azure_az_nodes) >= 2 ? 1 : 0
  name                = "master-1-slo"
  resource_group_name = volterra_azure_vnet_site.site.resource_group

}

data "azurerm_public_ip" "pib" {
  depends_on          = [module.site_wait_for_online]
  count               = length(var.f5xc_azure_az_nodes) >= 2 ? 1 : 0
  name                = "master-1-public-ip"
  resource_group_name = volterra_azure_vnet_site.site.resource_group
}

data "azurerm_network_interface" "sli" {
  depends_on          = [module.site_wait_for_online]
  count               = length(var.f5xc_azure_az_nodes) >= 2 ? 1 : 0
  name                = "master-2-sli"
  resource_group_name = volterra_azure_vnet_site.site.resource_group

}

data "azurerm_network_interface" "slo" {
  depends_on          = [module.site_wait_for_online]
  count               = length(var.f5xc_azure_az_nodes) >= 2 ? 1 : 0
  name                = "master-2-slo"
  resource_group_name = volterra_azure_vnet_site.site.resource_group

}

data "azurerm_public_ip" "pib" {
  depends_on          = [module.site_wait_for_online]
  count               = length(var.f5xc_azure_az_nodes) >= 2 ? 1 : 0
  name                = "master-2-public-ip"
  resource_group_name = volterra_azure_vnet_site.site.resource_group
}