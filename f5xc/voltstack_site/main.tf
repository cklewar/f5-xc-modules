resource "volterra_k8s_cluster" "cluster" {
  name                              = var.f5xc_cluster_name
  namespace                         = var.f5xc_namespace
  use_default_psp                   = true
  global_access_enable              = true
  no_cluster_wide_apps              = true
  no_insecure_registries            = true
  use_default_cluster_roles         = true
  cluster_scoped_access_permit      = true
  use_default_cluster_role_bindings = true

  local_access_config {
    local_domain = format("%s.local", var.f5xc_cluster_name)
    default_port = true
  }
}

resource "volterra_voltstack_site" "cluster" {
  name                    = var.f5xc_cluster_name
  namespace               = var.f5xc_namespace
  # master_nodes            = var.f5xc_master_nodes
  worker_nodes            = var.f5xc_worker_nodes
  deny_all_usb            = true
  disable_gpu             = true
  no_bond_devices         = true
  volterra_certified_hw   = var.f5xc_site_type_certified_hw[var.csp_provider][var.f5xc_ce_gateway_type]
  default_network_config  = true
  default_storage_config  = true
  logs_streaming_disabled = true

  dynamic "master_node_configuration" {
    for_each = var.f5xc_master_nodes
    content {
      name = master_node_configuration.value
    }
  }

  k8s_cluster {
    name      = volterra_k8s_cluster.cluster.name
    tenant    = var.f5xc_tenant
    namespace = var.f5xc_namespace
  }
}

module "kubeconfig" {
  depends_on            = [volterra_voltstack_site.cluster]
  source                = "../../utils/kubeconfig"
  f5xc_api_url          = var.f5xc_api_url
  f5xc_api_token        = var.f5xc_api_token
  f5xc_k8s_config_type  = "global"
  f5xc_k8s_cluster_name = var.f5xc_k8s_cluster_name
}
