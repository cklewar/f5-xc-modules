module "secure_mesh_site" {
  count                                  = var.f5xc_site_type_is_secure_mesh_site ? 1 : 0
  source                                 = "../../secure_mesh_site"
  csp_provider                           = "kvm"
  f5xc_nodes                             = [ for k in keys(var.f5xc_kvm_site_nodes) : { name = k } ]
  f5xc_api_url                           = var.f5xc_api_url
  f5xc_tenant                            = var.f5xc_tenant
  f5xc_namespace                         = var.f5xc_namespace
  f5xc_api_token                         = var.f5xc_api_token
  f5xc_cluster_name                      = var.f5xc_cluster_name
  f5xc_cluster_labels                    = var.f5xc_cluster_labels
  f5xc_ce_gateway_type                   = var.f5xc_ce_gateway_type
  f5xc_cluster_latitude                  = var.f5xc_cluster_latitude
  f5xc_cluster_longitude                 = var.f5xc_cluster_longitude
  f5xc_ce_performance_enhancement_mode   = var.f5xc_ce_performance_enhancement_mode
  f5xc_cluster_default_blocked_services  = var.f5xc_cluster_default_blocked_services
  f5xc_enable_offline_survivability_mode = var.f5xc_enable_offline_survivability_mode
}

module "node" {
  depends_on                        = [ module.secure_mesh_site ]
  source                            = "./nodes"
  for_each                          = {for k, v in var.f5xc_kvm_site_nodes : k => v}
  is_multi_nic                      = local.is_multi_nic
  is_multi_node                     = local.is_multi_node
  f5xc_api_url                      = var.f5xc_api_url
  f5xc_api_token                    = var.f5xc_api_token
  f5xc_namespace                    = var.f5xc_namespace
  f5xc_node_name                    = format("%s-%s", var.f5xc_cluster_name, each.key)
  f5xc_cluster_name                 = var.f5xc_cluster_name
  f5xc_cluster_latitude             = var.f5xc_cluster_latitude
  f5xc_cluster_longitude            = var.f5xc_cluster_longitude
  f5xc_ce_gateway_type              = var.f5xc_ce_gateway_type
  f5xc_kvm_site_nodes               = var.f5xc_kvm_site_nodes
  f5xc_qcow2_image                  = var.f5xc_qcow2_image
  f5xc_reg_url                      = var.f5xc_reg_url
  kvm_storage_pool                  = var.kvm_storage_pool
  kvm_instance_cpu_count            = var.kvm_instance_cpu_count
  kvm_instance_memory_size          = var.kvm_instance_memory_size
  kvm_instance_inside_network_name  = var.kvm_instance_inside_network_name
  kvm_instance_outside_network_name = var.kvm_instance_outside_network_name
}

module "site_wait_for_online" {
  depends_on        = [ module.node ]
  source            = "../../status/site"
  is_sensitive      = var.is_sensitive
  status_check_type = var.status_check_type
  f5xc_tenant       = var.f5xc_tenant
  f5xc_api_url      = var.f5xc_api_url
  f5xc_api_token    = var.f5xc_api_token
  f5xc_namespace    = var.f5xc_namespace
  f5xc_site_name    = var.f5xc_cluster_name
}
