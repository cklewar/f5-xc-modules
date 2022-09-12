output "vnet" {
  value = {
    name                = volterra_azure_vnet_site.site.name
    id                  = volterra_azure_vnet_site.site.id
    region              = volterra_azure_vnet_site.site.azure_region
    machine_type        = volterra_azure_vnet_site.site.machine_type
    vnet_resource_group = volterra_azure_vnet_site.site.resource_group
    params              = volterra_tf_params_action.azure_vnet_action
  }
}