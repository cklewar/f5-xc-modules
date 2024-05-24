locals {
  hosts_context_node = templatefile("${path.module}/${var.templates_dir}/hosts",
    {
      public_name    = var.f5xc_ce_hosts_public_name
      public_address = "127.0.0.1"
    }
  )

  azure_config = jsonencode({
    "cloud" : var.azurerm_cloud_name,
    "vmType" : var.azurerm_vm_type,
    "vnetName" : var.azurerm_vnet_name,
    "location" : var.azurerm_region,
    "tenantId" : var.azurerm_tenant_id,
    "subnetName" : var.azurerm_vnet_subnet_name,
    "aadClientId" : var.azurerm_client_id,
    "resourceGroup" : var.azurerm_resource_group,
    "aadClientSecret" : var.azurerm_client_secret,
    "subscriptionId" : var.azurerm_subscription_id,
    "securityGroupName" : var.azurerm_vnet_security_group,
    "vnetResourceGroup" : var.azurerm_vnet_resource_group,
    "primaryAvailabilitySetName" : var.azurerm_primary_availability_set
  })

  vpm_config = yamlencode({
    Vpm : {
      Token : var.f5xc_registration_token
      Labels : var.f5xc_cluster_labels,
      Latitude : var.f5xc_cluster_latitude,
      Longitude : var.f5xc_cluster_longitude,
      PrivateNIC : "eth0"
      ClusterName : var.f5xc_cluster_name,
      ClusterType : var.f5xc_cluster_type,
      MauriceEndpoint : var.maurice_endpoint,
      MauricePrivateEndpoint : var.maurice_mtls_endpoint,
      CertifiedHardwareEndpoint : var.f5xc_certified_hardware_endpoint,
    }
    Kubernetes : {
      CloudProvider : ""
      EtcdUseTLS : true
      Server : var.f5xc_ce_hosts_public_name
    }
  })

  cloud_cfg_master = var.node_type == var.node_type_master ? templatefile("../../modules/f5xc/ce/appstack/gcp/config/${var.templates_dir}/cloud_init.yaml", {
    ntp_servers       = var.ntp_servers
    azure_config      = base64encode(local.azure_config)
    hosts_context     = base64encode(local.hosts_context_node)
    ssh_public_key    = var.ssh_public_key
    admin_username    = var.azurerm_instance_admin_username
    reboot_strategy   = var.reboot_strategy_node
    vp_manager_config = base64encode(local.vpm_config)
  }) : null

  cloud_cfg_worker = var.node_type == var.node_type_worker ? templatefile("../../modules/f5xc/ce/appstack/gcp/config/${var.templates_dir}/cloud_init_worker.yaml", {
    ntp_servers       = var.ntp_servers
    azure_config      = base64encode(local.azure_config)
    hosts_context     = base64encode(local.hosts_context_node)
    ssh_public_key    = var.ssh_public_key
    admin_username    = var.azurerm_instance_admin_username
    reboot_strategy   = var.reboot_strategy_node
    vp_manager_config = base64encode(local.vpm_config)
  }) : null

}