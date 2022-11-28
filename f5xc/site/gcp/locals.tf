locals {
  f5xc_gcp_instance_name_pattern = format("instance_names = \\[\\n\\s*\"(%s-\\w*)\",\\n\\s*\\]", var.f5xc_gcp_site_name)
  f5xc_aws_ce_os_version         = var.f5xc_gcp_ce_os_version != "" && var.f5xc_gcp_default_ce_os_version == false ? var.f5xc_gcp_ce_os_version : null
  f5xc_aws_ce_sw_version         = var.f5xc_gcp_ce_sw_version != "" && var.f5xc_gcp_default_ce_sw_version == false ? var.f5xc_gcp_ce_sw_version : null
}