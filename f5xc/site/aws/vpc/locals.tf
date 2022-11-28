locals {
  f5xc_aws_ce_os_version   = var.f5xc_aws_ce_os_version != "" && var.f5xc_aws_default_ce_os_version == false ? var.f5xc_aws_ce_os_version : null
  f5xc_aws_ce_sw_version   = var.f5xc_aws_ce_sw_version != "" && var.f5xc_aws_default_ce_sw_version == false ? var.f5xc_aws_ce_sw_version : null
  f5xc_aws_tgw_common_tags = {
    "Deployment" = var.f5xc_aws_vpc_site_name
    "TTL"   = -1
  }
}