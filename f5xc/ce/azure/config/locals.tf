locals {
  hosts_context_node = templatefile("${path.module}/${var.templates_dir}/hosts",
    {
      public_name    = var.f5xc_ce_hosts_public_name
      public_address = var.f5xc_ce_hosts_public_address
    }
  )

  azure_config = jsonencode({
    "cloud" : var.azurerm_cloud_name,
    "tenantId" : var.azurerm_tenant_id,
    "subscriptionId" : var.azurerm_subscription_id,
    "aadClientId" : var.azurerm_client_id,
    "aadClientSecret" : var.azurerm_client_secret,
    "resourceGroup" : "${resource_group}",
    "location" : var.f5xc_azure_region,
    "vmType" : "vmss",
    "subnetName" : "${subnet_name}",
    "securityGroupName" : "security-group",
    "vnetName" : "network",
    "vnetResourceGroup" : "${network_resource_group}",
    "primaryAvailabilitySetName" : "availability-set-master"
  })

  vpm_config = yamlencode({
    "Vpm" : {
      "Token" : var.f5xc_site_token,
      "Labels" : var.f5xc_cluster_labels,
      "Latitude" : var.f5xc_cluster_latitude,
      "Longitude" : var.f5xc_cluster_longitude,
      "ClusterName" : var.f5xc_cluster_name,
      "ClusterType" : var.f5xc_cluster_type,
      "MauriceEndpoint" : var.maurice_endpoint,
      "MauricePrivateEndpoint" : var.maurice_mtls_endpoint,
      "CertifiedHardwareEndpoint" : var.f5xc_certified_hardware_endpoint,
    }
    Kubernetes : {
      "EtcdUseTLS" : true
      "Server" : var.f5xc_ce_hosts_public_name
    }
  })

  cloud_config = templatefile("${path.module}/${var.templates_dir}/cloud-init.yml",
    {
      ntp_servers       = var.ntp_servers
      azure_config      = base64encode(local.azure_config)
      hosts_context     = base64encode(local.hosts_context_node)
      ssh_public_key    = var.ssh_public_key
      reboot_strategy   = var.reboot_strategy_node
      vp_manager_config = base64encode(local.vpm_config)
    })
}