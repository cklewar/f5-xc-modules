resource "restful_resource" "token" {
  path = format(var.f5xc_token_base_uri, var.f5xc_namespace)
  read_path = format(var.f5xc_token_read_uri, var.f5xc_namespace, var.f5xc_sms_name)
  delete_path = format(var.f5xc_token_delete_uri, var.f5xc_namespace, var.f5xc_sms_name)
  header = {
    Content-Type = "application/json"
  }
  body = {
    metadata = {
      name      = var.f5xc_sms_name
      namespace = var.f5xc_namespace
    }
    spec = {
      type      = "JWT"
      site_name = var.f5xc_sms_name
    }
  }
}

resource "restful_resource" "site" {
  path = format(var.f5xc_sms_base_uri, var.f5xc_namespace)
  read_path = format(var.f5xc_sms_read_uri, var.f5xc_namespace, var.f5xc_sms_name)
  delete_path = format(var.f5xc_sms_delete_uri, var.f5xc_namespace, var.f5xc_sms_name)
  header = {
    Content-Type = "application/json"
  }
  body = {
    metadata = {
      name        = var.f5xc_sms_name
      labels      = var.f5xc_sms_labels
      disable     = var.f5xc_sms_disable
      namespace   = var.f5xc_namespace
      annotations = var.f5xc_sms_annotations
      description = var.f5xc_sms_description
    }
    spec = merge({
      (var.f5xc_sms_provider_name) = {
        not_managed = {}
      }
      software_settings            = local.software_settings
      performance_enhancement_mode = local.performance_enhancement_mode
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
    },
      local.spec
    )
  }
}