output "ce" {
  value = {
    config        = local.node
    user_data     = local.cloud_config
    gateway_type  = var.f5xc_ce_gateway_type
    hosts_context = local.hosts_context_node
  }
}