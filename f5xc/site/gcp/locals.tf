locals {
  f5xc_aws_ce_os_version        = var.f5xc_gcp_ce_os_version != "" && var.f5xc_gcp_default_ce_os_version == false ? var.f5xc_gcp_ce_os_version : null
  f5xc_aws_ce_sw_version        = var.f5xc_gcp_ce_sw_version != "" && var.f5xc_gcp_default_ce_sw_version == false ? var.f5xc_gcp_ce_sw_version : null
  f5xc_gcp_inside_network_name  = format("%s-network-inside", var.f5xc_gcp_site_name)
  f5xc_gcp_inside_subnet_name   = format("%s-subnet-inside", var.f5xc_gcp_site_name)
  f5xc_gcp_outside_network_name = format("%s-network-outside", var.f5xc_gcp_site_name)
  f5xc_gcp_outside_subnet_name  = format("%s-subnet-outside", var.f5xc_gcp_site_name)
}