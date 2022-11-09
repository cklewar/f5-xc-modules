output "vnet" {
  value = {
    id             = volterra_azure_vnet_site.site.id
    name           = volterra_azure_vnet_site.site.name
    sli_ip         = data.azurerm_network_interface.sli.private_ip_address
    slo_ip         = data.azurerm_network_interface.slo.private_ip_address
    region         = volterra_azure_vnet_site.site.azure_region
    public_ip      = data.azurerm_public_ip.pib.ip_address
    machine_type   = volterra_azure_vnet_site.site.machine_type
    resource_group = volterra_azure_vnet_site.site.resource_group
    params         = volterra_tf_params_action.azure_vnet_action
  }
}