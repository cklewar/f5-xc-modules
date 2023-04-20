locals {
  hosts_context_node = templatefile("${path.module}/${var.templates_dir}/hosts",
    {
      public_name    = var.f5xc_ce_hosts_public_name
      public_address = "127.0.0.1"
    }
  )

  azure_config = jsonencode({
    "cloud" : var.azurerm_cloud_name,
    "tenantId" : var.azurerm_tenant_id,
    "subscriptionId" : var.azurerm_subscription_id,
    "aadClientId" : var.azurerm_client_id,
    "aadClientSecret" : var.azurerm_client_secret,
    "resourceGroup" : var.azurerm_resource_group,
    "location" : var.f5xc_azure_region,
    "vmType" : var.azurerm_vm_type,
    "subnetName" : var.azurerm_vnet_subnet_name,
    "securityGroupName" : var.azurerm_vnet_security_group,
    "vnetName" : var.azurerm_vnet_name,
    "vnetResourceGroup" : var.azurerm_vnet_resource_group,
    "primaryAvailabilitySetName" : var.azurerm_primary_availability_set
  })

  vpm_config = yamlencode({
    Vpm : {
      Labels : var.f5xc_cluster_labels,
      Latitude : var.f5xc_cluster_latitude,
      Longitude : var.f5xc_cluster_longitude,
      ClusterName : var.f5xc_cluster_name,
      ClusterType : var.f5xc_cluster_type,
      Token : var.f5xc_registration_token
      MauriceEndpoint : var.maurice_endpoint,
      InsideNic : var.is_multi_nic ? "eth1" : null
      PrivateNIC : "eth0"
      MauricePrivateEndpoint : var.maurice_mtls_endpoint,
      CertifiedHardwareEndpoint : var.f5xc_certified_hardware_endpoint,
    }
    Kubernetes : {
      CloudProvider : ""
      EtcdUseTLS : true
      Server : var.f5xc_ce_hosts_public_name
    }
  })

  cloud_config = templatefile("${path.module}/${var.templates_dir}/cloud-init.yml",
    {
      ntp_servers       = var.ntp_servers
      user_pubkey       = var.ssh_public_key
      azure_config      = base64encode(local.azure_config)
      hosts_context     = base64encode(local.hosts_context_node)
      reboot_strategy   = var.reboot_strategy_node
      vp_manager_config = base64encode(local.vpm_config)
    })
}