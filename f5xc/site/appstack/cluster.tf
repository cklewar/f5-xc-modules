resource "volterra_token" "site" {
  name      = var.f5xc_cluster_name
  namespace = var.f5xc_namespace
}

module "maurice" {
  source       = "../../../../../modules/utils/maurice"
  f5xc_api_url = var.f5xc_api_url
}

resource "volterra_k8s_cluster" "cluster" {
  name                              = var.f5xc_cluster_name
  namespace                         = "system"
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
  depends_on = [terraform_data.master, terraform_data.worker]
  name       = var.f5xc_cluster_name
  namespace  = "system"

  k8s_cluster {
    namespace = "system"
    name      = volterra_k8s_cluster.cluster.name
  }

  master_nodes = [for k, v in terraform_data.master : format("%s-m%s", volterra_k8s_cluster.cluster.name, k)]
  worker_nodes = [for k, v in terraform_data.worker : format("%s-w%s", volterra_k8s_cluster.cluster.name, k)]

  no_bond_devices         = true
  disable_gpu             = true
  enable_vm               = var.kubevirt ? true : false
  disable_vm              = var.kubevirt ? false : true
  logs_streaming_disabled = true
  default_network_config  = true
  default_storage_config  = true
  deny_all_usb            = false
  volterra_certified_hw   = "kvm-voltstack-combo-softbank-large"
  #  sw {
  #    volterra_software_version = "crt-20240213-2651"
  #    #volterra_software_version = "crt-20240123-2647"
  #  }
  os {
    operating_system_version = "9.2024.6"
    #operating_system_version = "9.2023.29"
  }
}

resource "volterra_registration_approval" "master" {
  depends_on   = [volterra_voltstack_site.cluster, terraform_data.master]
  count        = var.master_nodes_count
  cluster_name = volterra_voltstack_site.cluster.name
  cluster_size = var.master_nodes_count
  hostname     = format("%s-m%d", volterra_voltstack_site.cluster.name, count.index)
  wait_time    = var.f5xc_registration_wait_time
  retry        = var.f5xc_registration_retry
}

module "site_wait_for_online" {
  depends_on     = [volterra_voltstack_site.cluster, terraform_data.worker]
  source         = "../../../../../modules/f5xc/status/site"
  f5xc_api_token = var.f5xc_api_token
  f5xc_api_url   = var.f5xc_api_url
  f5xc_namespace = var.f5xc_namespace
  f5xc_site_name = var.f5xc_cluster_name
  f5xc_tenant    = var.f5xc_tenant
  is_sensitive   = var.is_sensitive
}

resource "volterra_registration_approval" "worker" {
  depends_on   = [module.site_wait_for_online]
  count        = var.worker_nodes_count
  cluster_name = volterra_voltstack_site.cluster.name
  cluster_size = var.master_nodes_count
  hostname     = format("%s-w%d", volterra_voltstack_site.cluster.name, count.index)
  wait_time    = var.f5xc_registration_wait_time
  retry        = var.f5xc_registration_retry
}

resource "time_offset" "exp_time" {
  offset_days = 30
}

data "http" "kubeconfig" {
  depends_on      = [module.site_wait_for_online]
  url             = format("%s/web/namespaces/system/sites/%s/global-kubeconfigs", var.f5xc_api_url, var.f5xc_cluster_name)
  method          = "POST"
  request_headers = {
    # "only_once" hack (part 1) to only create it once (subsequent refresh and apply will fail)
    Authorization = fileexists(local.kubeconfig) ? "" : format("APIToken %s", var.f5xc_api_token)
  }
  request_body = jsonencode({ expiration_timestamp : time_offset.exp_time.rfc3339, site : var.f5xc_cluster_name })
}

resource "local_file" "kubeconfig" {
  # "only_once" hack (part 2) to never overwrite it after initial creation
  content  = fileexists(local.kubeconfig) ? file(local.kubeconfig) : data.http.kubeconfig.response_body
  filename = local.kubeconfig
}

