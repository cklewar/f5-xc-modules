resource restapi_object "secure_mesh_site" {
  provider     = restapi.f5xc
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
      rseries                                                             = var.f5xc_sms_provider_name == "rseries" ? local.spec_rseries : null
      re_select                                                           = var.f5xc_sms_re_select
      tunnel_type                                                         = var.f5xc_sms_tunnel_type
      no_forward_proxy                                                    = var.f5xc_sms_no_forward_proxy
      no_network_policy                                                   = var.f5xc_sms_no_network_policy
      software_settings                                                   = var.f5xc_sms_software_settings
      block_all_services                                                  = var.f5xc_sms_block_all_services
      tunnel_dead_timeout                                                 = var.f5xc_sms_tunnel_dead_timeout
      logs_streaming_disabled                                             = var.f5xc_sms_logs_streaming_disabled
      performance_enhancement_mode                                        = var.f5xc_sms_performance_enhancement_mode
      (var.f5xc_sms_master_nodes_count == 1 ? "disable_ha" : "enable_ha") = true
      offline_survivability_mode = {
        no_offline_survivability_mode     = !var.f5xc_sms_enable_offline_survivability_mode ? true : false
        enable_offline_survivability_mode = var.f5xc_sms_enable_offline_survivability_mode ? false : true
      }
    }
  })
}