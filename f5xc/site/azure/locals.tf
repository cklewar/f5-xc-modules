locals {
  f5xc_azure_ce_os_version       = var.f5xc_azure_ce_os_version != "" && var.f5xc_azure_default_ce_os_version == false ? var.f5xc_azure_ce_os_version : null
  f5xc_azure_ce_sw_version       = var.f5xc_azure_ce_sw_version != "" && var.f5xc_azure_default_ce_sw_version == false ? var.f5xc_azure_ce_sw_version : null
  f5xc_azure_outside_subnet_name = format("%s-outside-subnet", var.f5xc_azure_site_name)
  f5xc_azure_inside_subnet_name  = format("%s-inside-subnet", var.f5xc_azure_site_name)
}