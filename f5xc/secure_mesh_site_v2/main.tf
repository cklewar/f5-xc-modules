resource "restapi_object" "token" {
  path         = var.f5xc_token_base_uri
  id_attribute = "metadata/name"
  data = jsonencode({
    metadata = {
      name      = var.f5xc_sms_name
      namespace = var.f5xc_namespace
    }
    spec = {
      type      = "JWT"
      site_name = var.f5xc_sms_name
    }
  })
}

resource restapi_object "secure_mesh_site" {
  path         = var.f5xc_sms_base_uri
  id_attribute = "metadata/name"
  data = jsonencode({
    metadata = {
      name        = var.f5xc_sms_name
      labels      = var.f5xc_sms_labels
      disable     = var.f5xc_sms_disable
      namespace   = var.f5xc_namespace
      annotations = var.f5xc_sms_annotations
      description = var.f5xc_sms_description
    }
    spec = {
      (var.f5xc_sms_provider_name) = {
        not_managed = {}
      }
      performance_enhancement_mode = local.performance_enhancement_mode
      dc_cluster_group_slo = local.dc_cluster_group_slo
      dc_cluster_group_sli = local.dc_cluster_group_sli
      software_settings = var.f5xc_sms_default_sw_version && var.f5xc_sms_default_os_version ? {
        sw = { default_sw_version = {} }
        os = { default_os_version = {} }
      } : null /*var.f5xc_sms_default_sw_version && !var.f5xc_sms_default_os_version ? {
        sw = { default_sw_version = true }
        os = {
          default_os_version       = false
          operating_system_version = var.f5xc_sms_operating_system_version
        }
      } : !var.f5xc_sms_default_sw_version && var.f5xc_sms_default_os_version ? {
        sw = {
          default_sw_version        = false
          volterra_software_version = var.f5xc_sms_volterra_software_version
        }
        os = { default_os_version = true }
      } : !var.f5xc_sms_default_sw_version && !var.f5xc_sms_default_os_version ? {
        sw = {
          default_sw_version        = false
          volterra_software_version = var.f5xc_sms_volterra_software_version
        }
        os = {
          default_os_version       = false
          operating_system_version = var.f5xc_sms_operating_system_version
        }
      } : null*/
      re_select = {
        geo_proximity = {}
      }
      tunnel_type             = var.f5xc_sms_tunnel_type
      no_forward_proxy        = var.f5xc_sms_no_forward_proxy ? {} : null
      no_network_policy       = var.f5xc_sms_no_network_policy ? {} : null
      block_all_services      = var.f5xc_sms_block_all_services ? {} : null
      tunnel_dead_timeout     = var.f5xc_sms_tunnel_dead_timeout
      logs_streaming_disabled = var.f5xc_sms_logs_streaming_disabled ? {} : null
      enable_ha               = var.f5xc_sms_master_nodes_count == 1 ? null : {}
      offline_survivability_mode = {
        enable_offline_survivability_mode = var.f5xc_sms_enable_offline_survivability_mode ? {} : null
      }
    }
  })
}