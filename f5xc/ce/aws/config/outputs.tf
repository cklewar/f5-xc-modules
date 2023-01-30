output "ce" {
  value = {
    master-0 = {
      user_data     = local.cloud_init_master_config.config
      gateway_type  = var.f5xc_ce_gateway_type
      hosts_context = local.hosts_localhost.config
    }
  }
}


output "cloud_config_master_primary" {
  value = data.template_file.cloud_config_master_primary.rendered
}

output "cloud_config_master" {
  value = data.template_file.cloud_config_master.*.rendered
}

output "cloud_config_pool" {
  value = data.template_file.cloud_config_pool.rendered
}