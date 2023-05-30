locals {
  f5xc_service_vnet_name         = regex(local.f5xc_vnet_name_pattern, volterra_tf_params_action.azure_vnet_action.tf_output)[0]
  f5xc_vnet_name_pattern         = "volt_subnet_id_mappings\\s*=\\s*\\[{.*?\\\":\\\"\\/.*?virtualNetworks\\/(.*?)\\/subnets"
  f5xc_azure_ce_os_version       = var.f5xc_azure_ce_os_version != "" && var.f5xc_azure_default_ce_os_version == false ? var.f5xc_azure_ce_os_version : null
  f5xc_azure_ce_sw_version       = var.f5xc_azure_ce_sw_version != "" && var.f5xc_azure_default_ce_sw_version == false ? var.f5xc_azure_ce_sw_version : null
  f5xc_azure_outside_subnet_name = format("%s-outside-subnet", var.f5xc_azure_site_name)
  f5xc_azure_inside_subnet_name  = format("%s-inside-subnet", var.f5xc_azure_site_name)
}