output "vnet" {
  value = {
    id             = volterra_azure_vnet_site.site.id
    name           = volterra_azure_vnet_site.site.name
    region         = volterra_azure_vnet_site.site.azure_region
    params         = volterra_tf_params_action.azure_vnet_action
    machine_type   = volterra_azure_vnet_site.site.machine_type
    resource_group = volterra_azure_vnet_site.site.resource_group
    service_vnet   = var.f5xc_azure_existing_vnet_name == "" ? data.azurerm_virtual_network.service[0] : null
    nodes = {
      master-0 = {
        interfaces = {
          sli_ip     = var.f5xc_azure_ce_gw_type == var.f5xc_nic_type_multi_nic ? data.azurerm_network_interface.master-0-sli.*.private_ip_address : null
          slo_ip     = data.azurerm_network_interface.master-0-slo.private_ip_address
          sli_subnet = var.f5xc_azure_ce_gw_type == var.f5xc_nic_type_multi_nic ? data.azurerm_subnet.master-0-sli-subnet.0 : null
          slo_subnet = var.f5xc_azure_existing_vnet_name != "" ? data.azurerm_subnet.master-0-slo-subnet-existing : data.azurerm_subnet.master-0-slo-subnet
          public_ip  = data.azurerm_public_ip.master-0-pip.ip_address
        }
      }
      master-1 = length(var.f5xc_azure_az_nodes) == 3 ? {
        interfaces = {
          sli_ip     = var.f5xc_azure_ce_gw_type == var.f5xc_nic_type_multi_nic ? data.azurerm_network_interface.master-1-sli.*.private_ip_address : null
          slo_ip     = data.azurerm_network_interface.master-1-slo.*.private_ip_address
          sli_subnet = var.f5xc_azure_ce_gw_type == var.f5xc_nic_type_multi_nic ? data.azurerm_subnet.master-1-sli-subnet.0 : null
          slo_subnet = data.azurerm_subnet.master-1-slo-subnet
          public_ip  = data.azurerm_public_ip.master-1-pip.*.ip_address
        }
      } : null
      master-2 = length(var.f5xc_azure_az_nodes) == 3 ? {
        interfaces = {
          sli_ip     = var.f5xc_azure_ce_gw_type == var.f5xc_nic_type_multi_nic ? data.azurerm_network_interface.master-2-sli.*.private_ip_address : null
          slo_ip     = data.azurerm_network_interface.master-2-slo.*.private_ip_address
          sli_subnet = var.f5xc_azure_ce_gw_type == var.f5xc_nic_type_multi_nic ? data.azurerm_subnet.master-2-sli-subnet.0 : null
          slo_subnet = data.azurerm_subnet.master-2-slo-subnet
          public_ip  = data.azurerm_public_ip.master-2-pip.*.ip_address
        }
      } : null
    }
  }
}