locals {
  gateway_type       = replace(var.f5xc_ce_gateway_type, "_", "-")
  hosts_context_node = templatefile("${path.module}/${var.templates_dir}/hosts",
    {
      public_address = "127.0.1.1"
      public_name    = var.public_name
    }
  )
  hosts_context_pool = templatefile("${path.module}/${var.templates_dir}/hosts",
    {
      public_address = var.public_address
      public_name    = var.public_name
    }
  )
  vp_manager_environment = templatefile("${path.module}/${var.templates_dir}/vpm-environment",
    {
      vp_manager_version         = var.vp_manager_version
      vp_manager_image_separator = replace(var.vp_manager_version, "sha256:", "") == var.vp_manager_version ? ":" : "@"
    }
  )
  node = templatefile("${path.module}/${var.templates_dir}/vpm-${local.gateway_type}.yml",
    {
      is_pool                     = false
      public_nic                  = var.public_nic
      service_ip                  = var.public_name
      private_nic                 = var.private_nic
      cluster_name                = var.cluster_name
      cluster_type                = var.cluster_type
      cluster_token               = var.cluster_token
      cluster_labels              = var.cluster_labels
      cluster_workload            = var.cluster_workload
      cluster_latitude            = var.cluster_latitude
      cluster_longitude           = var.cluster_longitude
      image_Etcd                  = var.container_images["Etcd"]
      image_CoreDNS               = var.container_images["CoreDNS"]
      image_Hyperkube             = var.container_images["Hyperkube"]
      skip_stages                 = jsonencode(var.vp_manager_node_skip_stages)
      server_roles                = var.server_roles
      customer_route              = var.customer_route
      private_vn_prefix           = var.private_vn_prefix
      private_default_gw          = var.private_default_gw
      maurice_endpoint            = var.maurice_endpoint
      maurice_mtls_endpoint       = var.maurice_mtls_endpoint
      certified_hardware_endpoint = var.certified_hardware_endpoint
    }
  )
  node_pool = templatefile("${path.module}/${var.templates_dir}/vpm-${local.gateway_type}.yml",
    {
      is_pool                     = true
      service_ip                  = var.public_name
      server_roles                = jsonencode(["k8s-minion"])
      image_Hyperkube             = var.container_images["Hyperkube"]
      skip_stages                 = jsonencode(var.vp_manager_pool_skip_stages)
      public_nic                  = var.public_nic
      private_nic                 = var.private_nic
      cluster_uid                 = var.cluster_uid
      cluster_type                = var.cluster_type
      cluster_name                = var.cluster_name
      cluster_token               = var.cluster_token
      customer_route              = var.customer_route
      cluster_labels              = var.cluster_labels
      cluster_latitude            = var.cluster_latitude
      cluster_workload            = var.cluster_workload
      cluster_longitude           = var.cluster_longitude
      private_vn_prefix           = var.private_vn_prefix
      private_default_gw          = var.private_default_gw
      maurice_endpoint            = var.maurice_endpoint
      maurice_mtls_endpoint       = var.maurice_mtls_endpoint
      certified_hardware_endpoint = var.certified_hardware_endpoint
    }
  )
  # master-0, master-1, master-2, pool
  cloud_config = templatefile("${path.module}/${var.templates_dir}/cloud-init",
    {
      user_pubkey        = var.ssh_public_key
      ntp_servers        = var.ntp_servers
      hosts_context      = base64encode(local.hosts_context_node)
      reboot_strategy    = var.reboot_strategy_node
      vp_manager_context = base64encode(local.vp_manager_environment)
    }
  )
}