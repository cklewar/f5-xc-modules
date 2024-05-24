output "ce" {
  value = {
    vpm                = local.vpm_config
    user_data          = var.node_type == var.node_type_master ? local.cloud_cfg_master : local.cloud_cfg_worker
    hosts_context_node = local.hosts_context_node
  }
}