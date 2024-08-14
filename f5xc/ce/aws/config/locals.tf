locals {
  gateway_type       = replace(var.f5xc_ce_gateway_type, "_", "-")
  hosts_context_node = templatefile("${path.module}/${var.templates_dir}/hosts",
    {
      public_name    = var.f5xc_ce_hosts_public_name
      public_address = "127.0.1.1"
    }
  )

  hosts_context_pool = templatefile("${path.module}/${var.templates_dir}/hosts",
    {
      public_name    = var.f5xc_ce_hosts_public_name
      public_address = var.f5xc_ce_hosts_public_address
    }
  )

  vpm_config = yamlencode({
    Vpm = {
      Labels                    = var.f5xc_cluster_labels,
      Token                     = var.f5xc_site_token,
      Latitude                  = var.f5xc_cluster_latitude,
      Longitude                 = var.f5xc_cluster_longitude,
      InsideNIC                 = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? "eth1" : ""
      PrivateNIC                = "eth0"
      ClusterName               = var.f5xc_cluster_name,
      ClusterType               = var.f5xc_cluster_type,
      MauriceEndpoint           = var.maurice_endpoint,
      MauricePrivateEndpoint    = var.maurice_mtls_endpoint,
      CertifiedHardwareEndpoint = var.f5xc_certified_hardware_endpoint,
    }
    Kubernetes = {
      Server        = var.f5xc_ce_hosts_public_name
      EtcdUseTLS    = true
    }
  })

  cloud_config = templatefile("${path.module}/${var.templates_dir}/cloud-init.yml",
    {
      ntp_servers       = var.ntp_servers
      hosts_context     = base64encode(local.hosts_context_node)
      ssh_public_key    = var.ssh_public_key
      reboot_strategy   = var.reboot_strategy_node
      vp_manager_config = base64encode(local.vpm_config)
    })
}