output "vnet" {
  value = {
    id             = volterra_azure_vnet_site.site.id
    name           = volterra_azure_vnet_site.site.name
    region         = volterra_azure_vnet_site.site.azure_region
    machine_type   = volterra_azure_vnet_site.site.machine_type
    resource_group = volterra_azure_vnet_site.site.resource_group
    params         = volterra_tf_params_action.azure_vnet_action
    nodes          = {
      master-0 = {
        interfaces = {
          sli_ip    = data.azurerm_network_interface.master-0-sli.private_ip_address
          slo_ip    = data.azurerm_network_interface.master-0-slo.private_ip_address
          public_ip = data.azurerm_public_ip.master-0-pib.ip_address
        }
      }
      master-1 = {
        interfaces = {
          sli_ip    = data.azurerm_network_interface.master-1-sli.*.private_ip_address
          slo_ip    = data.azurerm_network_interface.master-1-slo.*.private_ip_address
          public_ip = data.azurerm_public_ip.master-1-pib.*.ip_address
        }
      }
      master-2 = {
        interfaces = {
          sli_ip    = data.azurerm_network_interface.master-2-sli.*.private_ip_address
          slo_ip    = data.azurerm_network_interface.master-2-slo.*.private_ip_address
          public_ip = data.azurerm_public_ip.master-2-pib.*.ip_address
        }
      }
    }
  }
}