locals {
  gateway_type       = replace(var.f5xc_ce_gateway_type, "_", "-")
  hosts_context_node = templatefile(file("${path.module}/${var.templates_dir}/hosts"),
    {
      public_address = "127.0.1.1"
      public_name    = var.public_name
    }
  )
  hosts_context_pool = templatefile(file("${path.module}/${var.templates_dir}/hosts"),
    {
      public_address = var.public_address
      public_name    = var.public_name
    }
  )
  vp_manager_environment = templatefile(file("${path.module}/resources/vpm-environment"),
    {
      vp_manager_version         = var.vp_manager_version
      vp_manager_image_separator = replace(var.vp_manager_version, "sha256:", "") == var.vp_manager_version ? ":" : "@"
    }
  )
  ce_gateway_primary = templatefile(file("${path.module}/${var.templates_dir}/vpm-${local.gateway_type}.yml"),
    {
      is_pool                     = false
      public_nic                  = var.public_nic
      service_ip                  = var.public_name
      private_nic                 = var.private_nic
      cluster_uid                 = var.cluster_uid
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
      # skip_stages                 = jsonencode(var.vp_manager_master_skip_stages)
      server_roles                = jsonencode(["etcd-server", "k8s-master-primary", "k8s-minion"])
      customer_route              = var.customer_route
      private_vn_prefix           = var.private_vn_prefix
      private_default_gw          = var.private_default_gw
      maurice_endpoint            = var.maurice_endpoint
      maurice_mtls_endpoint       = var.maurice_mtls_endpoint
      certified_hardware_endpoint = var.certified_hardware_endpoint
    }
  )
  ce_gateway = var.master_count - 1 > 0 ? templatefile(file("${path.module}/${var.templates_dir}/vpm-${local.gateway_type}.yml"),
    {
      is_pool                     = false
      public_nic                  = var.public_nic
      service_ip                  = var.public_name
      private_nic                 = var.private_nic
      cluster_uid                 = var.cluster_uid
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
      # skip_stages                 = jsonencode(var.vp_manager_master_skip_stages)
      server_roles                = jsonencode(["etcd-server", "k8s-master", "k8s-minion"])
      customer_route              = var.customer_route
      private_vn_prefix           = var.private_vn_prefix
      private_default_gw          = var.private_default_gw
      maurice_endpoint            = var.maurice_endpoint
      maurice_mtls_endpoint       = var.maurice_mtls_endpoint
      certified_hardware_endpoint = var.certified_hardware_endpoint
    }
  ) : null
  ce_gateway_pool = templatefile(file("${path.module}/${var.templates_dir}/vpm-${local.gateway_type}.yml"),
    {
      is_pool                     = true
      service_ip                  = var.public_name
      server_roles                = jsonencode(["k8s-minion"])
      image_Hyperkube             = var.container_images["Hyperkube"]
      # skip_stages                 = jsonencode(var.vp_manager_skip_stages)
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
  # node-0, node-1, node-2
  cloud_config_node_0 = templatefile(file("${path.module}/${var.templates_dir}/cloud-init"),
    {
      user_pubkey        = var.ssh_public_key
      ntp_servers        = var.ntp_servers
      hosts_context      = base64encode(local.hosts_context_node)
      reboot_strategy    = var.reboot_strategy_node
      vp_manager_context = base64encode(data.template_file.vp_manager_master_primary.rendered)
    }
  )
  # pool
  cloud_config_pool = templatefile(file("${path.module}/${var.templates_dir}/cloud-init.yml"),
    {
      user_pubkey        = var.ssh_public_key
      ntp_servers        = var.ntp_servers
      hosts_context      = base64encode(local.hosts_context_pool)
      reboot_strategy    = var.reboot_strategy_pool
      vp_manager_context = base64encode(data.template_file.vp_manager_pool.rendered)
    }
  )
}