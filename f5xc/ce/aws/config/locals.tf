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
  node = yamldecode(
    {
      "Vpm" : {
        # "Roles" : var.server_roles,
        "SkipStages" : var.vp_manager_node_skip_stages || var.vp_manager_pool_skip_stages,
        "ClusterUid" : var.cluster_uid,
        "DisableModules" : [],
        "ClusterName" : var.cluster_name,
        "ClusterType" : var.cluster_type,
        "Token" : var.cluster_token,
        "InsideNIC" : var.public_nic,
        "PrivateNIC" : var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? var.private_nic : null,
        "PrivateDefaultGw" : var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ?var.private_default_gw : null,
        "PrivateVnPrefix" : var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? var.private_vn_prefix : null,
        "CustomerRoute" : var.customer_route,
        "Latitude" : var.cluster_latitude,
        "Longitude" : var.cluster_longitude,
        "MauricePrivateEndpoint" : var.maurice_mtls_endpoint,
        "MauriceEndpoint" : maurice_endpoint,
        "Labels" : var.cluster_labels,
        "CertifiedHardwareEndpoint" : var.certified_hardware_endpoint,
      },
      Workload : var.cluster_workload,
      Kubernetes : {
        "CloudProvider" : "",
        # "EtcdClusterServers" : [] # Only when pool
        "EtcdUseTLS" : True # Only when node
        "Server" : var.service_ip
        "Images" : {
          "Hyperkube" : var.container_images["Hyperkube"]
          "CoreDNS" : var.container_images["CoreDNS"] # Only when node
          "Etcd" : var.container_images["Etcd"] # Only when node
        }
      }
    }
  )

  cloud_config = templatefile("${path.module}/${var.templates_dir}/cloud-init.yml",
    {
      user_pubkey        = var.ssh_public_key
      ntp_servers        = var.ntp_servers
      hosts_context      = base64encode(local.hosts_context_node)
      reboot_strategy    = var.reboot_strategy_node
      vp_manager_context = base64encode(local.vp_manager_environment)
    }
  )
}