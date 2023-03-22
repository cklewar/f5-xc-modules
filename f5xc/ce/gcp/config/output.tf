output "ce" {
  value = {
    master-0 = {
      user_data     = local.cloud_init_master_config.config
      gateway_type  = local.gateway_type
      hosts_context = local.hosts_localhost.config
    }
  }
}