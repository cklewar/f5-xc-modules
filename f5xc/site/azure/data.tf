data "azurerm_network_interface" "sli" {
  depends_on          = [volterra_azure_vnet_site.site]
  name                = "master-0-sli"
  resource_group_name = var.f5xc_azure_vnet_site_resource_group

}

data "azurerm_network_interface" "slo" {
  depends_on          = [volterra_azure_vnet_site.site]
  name                = "master-0-slo"
  resource_group_name = var.f5xc_azure_vnet_site_resource_group

}

data "azurerm_public_ip" "pib" {
  depends_on          = [volterra_azure_vnet_site.site]
  name                = "master-0-public-ip"
  resource_group_name = var.f5xc_azure_vnet_site_resource_group
}