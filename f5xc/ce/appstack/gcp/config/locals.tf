locals {
  hosts_context_node = templatefile(abspath("../../modules/f5xc/ce/appstack/gcp/config/${var.templates_dir}/hosts"),
    {
      public_address = "127.0.1.1"
      public_name    = var.f5xc_ce_hosts_public_name
    }
  )

  vpm_config = yamlencode({
    Vpm = {
      Labels                    = var.f5xc_cluster_labels,
      Token                     = var.f5xc_site_token,
      Labels                    = var.f5xc_cluster_labels,
      Latitude                  = var.f5xc_cluster_latitude,
      Longitude                 = var.f5xc_cluster_longitude,
      ClusterName               = var.f5xc_cluster_name,
      ClusterType               = var.f5xc_cluster_type,
      MauriceEndpoint           = var.maurice_endpoint,
      MauricePrivateEndpoint    = var.maurice_mtls_endpoint,
      CertifiedHardwareEndpoint = var.f5xc_certified_hardware_endpoint,
    }
    Kubernetes = {
      Server        = var.f5xc_ce_hosts_public_name
      EtcdUseTLS    = true
      CloudProvider = ""
    }
  })

  cloud_cfg_master = var.node_type == var.node_type_master ? templatefile("../../modules/f5xc/ce/appstack/gcp/config/${var.templates_dir}/cloud_init.yaml", {
    ntp_servers       = var.ntp_servers
    hosts_context     = base64encode(local.hosts_context_node)
    ssh_public_key    = var.ssh_public_key
    reboot_strategy   = var.reboot_strategy_node
    vp_manager_config = base64encode(local.vpm_config)
  }) : null

  cloud_cfg_worker = var.node_type == var.node_type_worker ? templatefile("../../modules/f5xc/ce/appstack/gcp/config/${var.templates_dir}/cloud_init_worker.yaml", {
    ntp_servers       = var.ntp_servers
    ssh_public_key    = var.ssh_public_key
    reboot_strategy   = var.reboot_strategy_node
    vp_manager_config = base64encode(local.vpm_config)
  }) : null
}