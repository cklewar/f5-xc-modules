locals {
  f5xc_instance_names            = [for name in split(",", regex(local.f5xc_gcp_instance_name_pattern, volterra_tf_params_action.gcp_vpc_action.tf_output)[0]) : trim(name, "\"")]
  f5xc_gcp_instance_name_pattern = "instance_names\\s*=\\s*\\[\"(.*?)\"\\]"
  f5xc_aws_ce_os_version         = var.f5xc_gcp_ce_os_version != "" && var.f5xc_gcp_default_ce_os_version == false ? var.f5xc_gcp_ce_os_version : null
  f5xc_aws_ce_sw_version         = var.f5xc_gcp_ce_sw_version != "" && var.f5xc_gcp_default_ce_sw_version == false ? var.f5xc_gcp_ce_sw_version : null
}