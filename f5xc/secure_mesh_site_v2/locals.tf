locals {
  algorithm = jsondecode(base64decode(split(".", split("content:", split("map[", split(" ", restapi_object.token.api_data.spec)[0])[1])[1])[0]))
  api_response = jsondecode(restapi_object.token.api_response)
  performance_enhancement_mode = [
    { f5xc_sms_perf_mode_l7_enhanced = {} }, {
      perf_mode_l3_enhanced = {
        jumbo = {}
      }
    }
  ][var.f5xc_sms_perf_mode_l7_enhanced ? 0 : 1]

  dc_cluster_group_slo = [
    {
      name      = var.f5xc_dc_cluster_group_slo_name
      tenant    = var.f5xc_tenant
      namespace = var.f5xc_namespace
    }, {}
  ][var.f5xc_dc_cluster_group_slo_name != null ? 0 : 1]
  dc_cluster_group_sli = [
    {
      name      = var.f5xc_dc_cluster_group_sli_name
      tenant    = var.f5xc_tenant
      namespace = var.f5xc_namespace
    }, {}
  ][var.f5xc_dc_cluster_group_sli_name != null ? 0 : 1]

  software_settings = [
    {
      sw = { default_sw_version = true }
        os = {
          default_os_version       = false
          operating_system_version = var.f5xc_sms_operating_system_version
        }
    },
    {
       sw = {
          default_sw_version        = false
          volterra_software_version = var.f5xc_sms_volterra_software_version
        }
        os = { default_os_version = true }
    },
    {
      sw = {
          default_sw_version        = false
          volterra_software_version = var.f5xc_sms_volterra_software_version
        }
        os = {
          default_os_version       = false
          operating_system_version = var.f5xc_sms_operating_system_version
        }
    },
    {
      sw = { default_sw_version = {} }
      os = { default_os_version = {} }
    }
  ][var.f5xc_sms_default_sw_version && !var.f5xc_sms_default_os_version ? 0 : !var.f5xc_sms_default_sw_version && var.f5xc_sms_default_os_version ? 1 : !var.f5xc_sms_default_sw_version && !var.f5xc_sms_default_os_version ? 2 : 3]

  spec = merge({},
      var.f5xc_dc_cluster_group_slo_name != null ? {
      dc_cluster_group_slo = local.dc_cluster_group_slo
    } : {},
      var.f5xc_dc_cluster_group_sli_name != null ? {
      dc_cluster_group_sli = local.dc_cluster_group_sli
    } : {}
  )
}