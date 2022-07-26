locals {
  hosts_localhost = templatefile(format("%s/resources/hosts", path.module), {
    public_address = "127.0.1.1"
    public_name    = var.public_name
  })

  hosts_balancer = templatefile(format("%s/resources/hosts", path.module), {
    public_address = var.public_address
    public_name    = var.public_name
  })

  vp_manager_master_primary = templatefile(format("%s/resources/vpm-master.yml", path.module), {
    cluster_uid                 = var.cluster_uid
    service_cidr                = var.service_cidr
    cluster_cidr                = var.cluster_cidr
    server_roles                = jsonencode(["etcd-server", "k8s-master-primary", "k8s-minion"])
    dns_service_ip              = var.dns_service_ip
    sre_dns_service_ip          = var.sre_dns_service_ip
    service_ip                  = var.public_name
    etcd_servers                = jsonencode(var.cluster_members)
    # ^^ DEPRECATED
    kube_api_servers            = jsonencode([var.public_address])
    image_Hyperkube             = var.container_images["Hyperkube"]
    image_CoreDNS               = var.container_images["CoreDNS"]
    image_Etcd                  = var.container_images["Etcd"]
    bootstrap_token_id          = "xxx"
    bootstrap_token_secret      = "yyy"
    etcd_initial_token          = var.etcd_initial_token
    dns_zone                    = var.dns_zone_name
    skip_stages                 = jsonencode(var.vp_manager_master_skip_stages)
    cluster_type                = var.vp_manager_type
    cluster_name                = var.cluster_name
    public_nic                  = var.nic_public
    private_nic                 = var.nic_fabric
    private_default_gw          = var.private_default_gw
    private_vn_prefix           = var.private_vn_prefix
    cluster_token               = var.cluster_token
    customer_route              = var.customer_route
    cluster_latitude            = var.cluster_latitude
    cluster_longitude           = var.cluster_longitude
    cluster_workload            = var.cluster_workload
    cluster_labels              = var.cluster_labels
    maurice_endpoint            = var.maurice_endpoint
    maurice_mtls_endpoint       = var.maurice_mtls_endpoint
    pikachu_endpoint            = var.pikachu_endpoint
    certified_hardware_endpoint = var.certified_hardware_endpoint
  })

  vp_manager_master = templatefile(format("%s/resources/vpm-master.yml", path.module), {
    cluster_uid                 = var.cluster_uid
    service_cidr                = var.service_cidr
    cluster_cidr                = var.cluster_cidr
    server_roles                = jsonencode(["etcd-server", "k8s-master", "k8s-minion"])
    dns_service_ip              = var.dns_service_ip
    sre_dns_service_ip          = var.sre_dns_service_ip
    service_ip                  = var.public_name
    etcd_servers                = jsonencode(var.cluster_members)
    # ^^ DEPRECATED
    kube_api_servers            = jsonencode([var.public_address])
    image_Hyperkube             = var.container_images["Hyperkube"]
    image_CoreDNS               = var.container_images["CoreDNS"]
    image_Etcd                  = var.container_images["Etcd"]
    bootstrap_token_id          = var.bootstrap_token_id
    bootstrap_token_secret      = var.bootstrap_token_secret
    etcd_initial_token          = var.etcd_initial_token
    dns_zone                    = var.dns_zone_name
    skip_stages                 = jsonencode(var.vp_manager_master_skip_stages)
    cluster_name                = var.cluster_name
    public_nic                  = var.nic_public
    private_nic                 = var.nic_fabric
    private_default_gw          = var.private_default_gw
    private_vn_prefix           = var.private_vn_prefix
    cluster_token               = var.cluster_token
    customer_route              = var.customer_route
    cluster_type                = var.vp_manager_type
    cluster_latitude            = var.cluster_latitude
    cluster_longitude           = var.cluster_longitude
    cluster_workload            = var.cluster_workload
    cluster_labels              = var.cluster_labels
    maurice_endpoint            = var.maurice_endpoint
    maurice_mtls_endpoint       = var.maurice_mtls_endpoint
    pikachu_endpoint            = var.pikachu_endpoint
    certified_hardware_endpoint = var.certified_hardware_endpoint
  })

  vp_manager_pool = templatefile(format("%s/resources/vpm-pool.yml", path.module), {
    cluster_uid                 = var.cluster_uid
    cluster_cidr                = var.cluster_cidr
    server_roles                = jsonencode(["k8s-minion"])
    service_ip                  = var.public_name
    image_Hyperkube             = var.container_images["Hyperkube"]
    skip_stages                 = jsonencode(var.vp_manager_skip_stages)
    cluster_type                = var.vp_manager_type
    cluster_name                = var.cluster_name
    public_nic                  = var.nic_public
    private_nic                 = var.nic_fabric
    private_default_gw          = var.private_default_gw
    private_vn_prefix           = var.private_vn_prefix
    cluster_token               = var.cluster_token
    customer_route              = var.customer_route
    cluster_latitude            = var.cluster_latitude
    cluster_longitude           = var.cluster_longitude
    cluster_workload            = var.cluster_workload
    cluster_labels              = var.cluster_labels
    maurice_endpoint            = var.maurice_endpoint
    maurice_mtls_endpoint       = var.maurice_mtls_endpoint
    pikachu_endpoint            = var.pikachu_endpoint
    certified_hardware_endpoint = var.certified_hardware_endpoint
  })

  vp_manager_environment = templatefile(format("%s/resources/vpm-environment", path.module), {
    vp_manager_image_separator = replace(var.vp_manager_version, "sha256:", "") == var.vp_manager_version ? ":" : "@"
    vp_manager_version         = var.vp_manager_version
  })

  # 1st cluster node
  cloud_config_master_primary = templatefile(format("%s/resources/cloud-config-master-${var.template_suffix}.yml", path.module), {
    reboot_strategy                = var.reboot_strategy_master
    vp_manager_context             = base64encode(local.vp_manager_master_primary)
    vp_manager_environment_context = base64encode(local.vp_manager_environment)
    hosts_context                  = base64encode(local.hosts_localhost)
    hugepages_service              = var.mask_hugepages_service
    user_name                      = var.user_name
    user_password                  = var.user_password
    user_pubkey                    = var.user_pubkey
    ssh_trusted_user_ca            = local.ssh_trusted_user_ca
    # physical aws only RE/CE
    ntp_servers                    = var.ntp_servers
    nic_public                     = var.nic_public
    nic_public_domain              = var.public_name
    nic_fabric                     = var.nic_fabric
    vp_manager_mask_fetch_latest   = var.vp_manager_mask_fetch_latest
  })

  # 2nd and other cluster nodes
  cloud_config_master = templatefile(format("%s/resources/cloud-config-master-${var.template_suffix}.yml", path.module), {
    reboot_strategy    = var.reboot_strategy_master
    vp_manager_context = base64encode(
      element(local.vp_manager_master.*, var.master_count - 1),
    )
    vp_manager_environment_context = base64encode(local.vp_manager_environment)
    hosts_context                  = base64encode(local.hosts_localhost)
    hugepages_service              = var.mask_hugepages_service
    user_name                      = var.user_name
    user_password                  = var.user_password
    user_pubkey                    = var.user_pubkey
    ssh_trusted_user_ca            = local.ssh_trusted_user_ca
    # physical aws only
    ntp_servers                    = var.ntp_servers
    nic_public                     = var.nic_public
    nic_public_domain              = var.public_name
    nic_fabric                     = var.nic_fabric
    vp_manager_mask_fetch_latest   = var.vp_manager_mask_fetch_latest
  })

  cloud_config_pool = templatefile(format("%s/resources/cloud-config-pool-${var.template_suffix}.yml", path.module), {
    reboot_strategy                = var.reboot_strategy_pool
    vp_manager_context             = base64encode(local.vp_manager_pool)
    vp_manager_environment_context = base64encode(local.vp_manager_environment)
    hosts_context                  = base64encode(local.hosts_balancer)
    hugepages_service              = "false"
    user_name                      = var.user_name
    user_password                  = var.user_password
    user_pubkey                    = var.user_pubkey
    ssh_trusted_user_ca            = local.ssh_trusted_user_ca
    # physical aws only
    ntp_servers                    = var.ntp_servers
    nic_public                     = var.nic_public
    nic_fabric                     = var.nic_fabric
    vp_manager_mask_fetch_latest   = var.vp_manager_mask_fetch_latest
  })

  ssh_trusted_user_ca = join(
    "\n",
    [var.ssh_trusted_user_ca_map[var.ves_env]],
    [var.ssh_trusted_user_lockout_ca],
  )
}