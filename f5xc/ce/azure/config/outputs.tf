output "ce" {
  value = {
    config        = local.vpm_config
    user_data     = local.cloud_config
    hosts_context = local.hosts_context_node
  }
}