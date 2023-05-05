locals {
  gateway_type = replace(var.f5xc_ce_gateway_type, "_", "-")
  vpm_vars     = {
    service_ip                  = var.host_localhost_public_name
    cluster_type                = var.cluster_type
    cluster_name                = var.cluster_name
    private_nic                 = var.slo_nic
    cluster_token               = var.volterra_token
    cluster_latitude            = var.f5xc_cluster_latitude
    cluster_longitude           = var.f5xc_cluster_longitude
    maurice_endpoint            = var.maurice_endpoint
    maurice_mtls_endpoint       = var.maurice_mtls_endpoint
    certified_hardware_endpoint = var.certified_hardware_endpoint
    cluster_labels              = var.cluster_labels
  }

  hosts_localhost_vars = {
    public_address = var.host_localhost_public_address
    public_name    = var.host_localhost_public_name
  }

  cloud_init_master = {
    vp_manager_context = base64encode(local.vpm_config.config)
    hosts_context      = base64encode(local.hosts_localhost.config)
    user_pubkey        = var.ssh_public_key
  }

  hosts_localhost = {
    config = templatefile("${path.module}/templates/hosts", local.hosts_localhost_vars)
  }

  vpm_config = {
    config = templatefile("${path.module}/templates/vpm-${local.gateway_type}.yml", local.vpm_vars)
  }

  cloud_init_master_config = {
    config = templatefile("${path.module}/templates/cloud-init.yml", local.cloud_init_master)
  }
}