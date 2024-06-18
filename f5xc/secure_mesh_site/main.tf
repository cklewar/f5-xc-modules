resource "volterra_securemesh_site" "secure_mesh_site" {
  name                     = var.f5xc_cluster_name
  labels                   = var.f5xc_cluster_labels
  namespace                = var.f5xc_namespace
  worker_nodes             = var.f5xc_cluster_worker_nodes
  no_bond_devices          = var.f5xc_cluster_no_bond_devices ? var.f5xc_cluster_no_bond_devices : null
  volterra_certified_hw    = var.f5xc_site_type_certified_hw[var.csp_provider][var.f5xc_ce_gateway_type]
  default_network_config   = var.f5xc_cluster_default_network_config
  logs_streaming_disabled  = var.f5xc_cluster_logs_streaming_disabled
  default_blocked_services = var.f5xc_cluster_default_blocked_services

  os {
    default_os_version       = var.f5xc_default_os_version
    operating_system_version = !var.f5xc_default_os_version ? var.f5xc_operating_system_version : null
  }

  sw {
    default_sw_version        = var.f5xc_default_sw_version
    volterra_software_version = !var.f5xc_default_sw_version ? var.f5xc_volterra_software_version : null
  }

  /*dynamic "bond_device_list" {
  }*/

  offline_survivability_mode {
    no_offline_survivability_mode     = var.f5xc_enable_offline_survivability_mode == false ? true : false
    enable_offline_survivability_mode = var.f5xc_enable_offline_survivability_mode ? true : false
  }

  performance_enhancement_mode {
    perf_mode_l7_enhanced = var.f5xc_ce_performance_enhancement_mode.perf_mode_l7_enhanced ? true : false
    dynamic "perf_mode_l3_enhanced" {
      for_each = var.f5xc_ce_performance_enhancement_mode.perf_mode_l7_enhanced == false ? [1] : []
      content {
        jumbo    = var.f5xc_ce_performance_enhancement_mode.perf_mode_l3_enhanced.jumbo_frame_enabled ? true : false
        no_jumbo = var.f5xc_ce_performance_enhancement_mode.perf_mode_l3_enhanced.jumbo_frame_enabled == false ? true : false
      }
    }
  }

  dynamic "master_node_configuration" {
    for_each = var.f5xc_nodes
    content {
      name      = master_node_configuration.value.name
      public_ip = master_node_configuration.value.public_ip
    }
  }
}