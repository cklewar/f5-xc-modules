output "vnet" {
  value = {
    name         = volterra_azure_vnet_site.vnet.name
    id           = volterra_azure_vnet_site.vnet.id
    region       = volterra_azure_vnet_site.vnet.azure_region
    machine_type = volterra_azure_vnet_site.vnet.machine_type
    params       = volterra_tf_params_action.azure_vnet_action
  }
}