data "template_file" "hosts_localhost" {
  template = file("${path.module}/resources/hosts")

  vars = {
    public_address = "127.0.1.1"
    public_name    = var.public_name
  }
}

data "template_file" "hosts_balancer" {
  template = file("${path.module}/resources/hosts")

  vars = {
    public_address = var.public_address
    public_name    = var.public_name
  }
}

data "template_file" "vp_manager_master_primary" {
  template = file("${path.module}/resources/vpm-master.yml")

  vars = {
    cluster_uid        = var.cluster_uid
    service_cidr       = var.service_cidr
    cluster_cidr       = var.cluster_cidr
    server_roles       = jsonencode(["etcd-server", "k8s-master-primary", "k8s-minion"])
    dns_service_ip     = var.dns_service_ip
    sre_dns_service_ip = var.sre_dns_service_ip
    service_ip         = var.public_name
    etcd_servers       = jsonencode(var.cluster_members)
    # ^^ DEPRECATED
    kube_api_servers       = jsonencode([var.public_address])
    image_Hyperkube        = var.container_images["Hyperkube"]
    image_CoreDNS          = var.container_images["CoreDNS"]
    image_Etcd             = var.container_images["Etcd"]
    bootstrap_token_id     = "xxx"
    bootstrap_token_secret = "yyy"
    etcd_initial_token     = var.etcd_initial_token
    dns_zone               = var.dns_zone_name
    skip_stages            = jsonencode(var.vp_manager_master_skip_stages)
    cluster_type           = var.vp_manager_type
    cluster_name           = var.cluster_name
    public_nic             = var.nic_public
    private_nic            = var.nic_fabric
    private_default_gw     = var.private_default_gw
    private_vn_prefix      = var.private_vn_prefix
    cluster_token          = var.cluster_token
    customer_route         = var.customer_route
    cluster_latitude       = var.cluster_latitude
    cluster_longitude      = var.cluster_longitude
    cluster_workload       = var.cluster_workload
    cluster_labels         = var.cluster_labels
    maurice_endpoint       = var.maurice_endpoint
    maurice_mtls_endpoint  = var.maurice_mtls_endpoint
    pikachu_endpoint       = var.pikachu_endpoint
    certified_hardware_endpoint     = var.certified_hardware_endpoint
  }
}

data "template_file" "vp_manager_master" {
  template = file("${path.module}/resources/vpm-master.yml")
  count    = var.master_count - 1

  vars = {
    cluster_uid        = var.cluster_uid
    service_cidr       = var.service_cidr
    cluster_cidr       = var.cluster_cidr
    server_roles       = jsonencode(["etcd-server", "k8s-master", "k8s-minion"])
    dns_service_ip     = var.dns_service_ip
    sre_dns_service_ip = var.sre_dns_service_ip
    service_ip         = var.public_name
    etcd_servers       = jsonencode(var.cluster_members)
    # ^^ DEPRECATED
    kube_api_servers       = jsonencode([var.public_address])
    image_Hyperkube        = var.container_images["Hyperkube"]
    image_CoreDNS          = var.container_images["CoreDNS"]
    image_Etcd             = var.container_images["Etcd"]
    bootstrap_token_id     = var.bootstrap_token_id
    bootstrap_token_secret = var.bootstrap_token_secret
    etcd_initial_token     = var.etcd_initial_token
    dns_zone               = var.dns_zone_name
    skip_stages            = jsonencode(var.vp_manager_master_skip_stages)
    cluster_name           = var.cluster_name
    public_nic             = var.nic_public
    private_nic            = var.nic_fabric
    private_default_gw     = var.private_default_gw
    private_vn_prefix      = var.private_vn_prefix
    cluster_token          = var.cluster_token
    customer_route         = var.customer_route
    cluster_type           = var.vp_manager_type
    cluster_latitude       = var.cluster_latitude
    cluster_longitude      = var.cluster_longitude
    cluster_workload       = var.cluster_workload
    cluster_labels         = var.cluster_labels
    maurice_endpoint       = var.maurice_endpoint
    maurice_mtls_endpoint  = var.maurice_mtls_endpoint
    pikachu_endpoint       = var.pikachu_endpoint
    certified_hardware_endpoint     = var.certified_hardware_endpoint
  }
}

data "template_file" "vp_manager_pool" {
  template = file("${path.module}/resources/vpm-pool.yml")

  vars = {
    cluster_uid           = var.cluster_uid
    cluster_cidr          = var.cluster_cidr
    server_roles          = jsonencode(["k8s-minion"])
    service_ip            = var.public_name
    image_Hyperkube       = var.container_images["Hyperkube"]
    skip_stages           = jsonencode(var.vp_manager_skip_stages)
    cluster_type          = var.vp_manager_type
    cluster_name          = var.cluster_name
    public_nic            = var.nic_public
    private_nic           = var.nic_fabric
    private_default_gw    = var.private_default_gw
    private_vn_prefix     = var.private_vn_prefix
    cluster_token         = var.cluster_token
    customer_route        = var.customer_route
    cluster_latitude      = var.cluster_latitude
    cluster_longitude     = var.cluster_longitude
    cluster_workload      = var.cluster_workload
    cluster_labels        = var.cluster_labels
    maurice_endpoint      = var.maurice_endpoint
    maurice_mtls_endpoint = var.maurice_mtls_endpoint
    pikachu_endpoint      = var.pikachu_endpoint
    certified_hardware_endpoint    = var.certified_hardware_endpoint
  }
}

data "template_file" "vp_manager_environment" {
  template = file("${path.module}/resources/vpm-environment")

  vars = {
    vp_manager_image_separator = replace(var.vp_manager_version, "sha256:", "") == var.vp_manager_version ? ":" : "@"
    vp_manager_version         = var.vp_manager_version
  }
}

# 1st cluster node
data "template_file" "cloud_config_master_primary" {
  template = file(
    "${path.module}/resources/cloud-config-master-${var.template_suffix}.yml",
  )

  vars = {
    reboot_strategy                = var.reboot_strategy_master
    vp_manager_context             = base64encode(data.template_file.vp_manager_master_primary.rendered)
    vp_manager_environment_context = base64encode(data.template_file.vp_manager_environment.rendered)
    hosts_context                  = base64encode(data.template_file.hosts_localhost.rendered)
    hugepages_service              = var.mask_hugepages_service
    user_name                      = var.user_name
    user_password                  = var.user_password
    user_pubkey                    = var.user_pubkey
    ssh_trusted_user_ca            = local.ssh_trusted_user_ca
    # physical aws only RE/CE
    ntp_servers                  = var.ntp_servers
    nic_public                   = var.nic_public
    nic_public_domain            = var.public_name
    nic_fabric                   = var.nic_fabric
    vp_manager_mask_fetch_latest = var.vp_manager_mask_fetch_latest
  }
}

# 2nd and other cluster nodes
data "template_file" "cloud_config_master" {
  template = file(
    "${path.module}/resources/cloud-config-master-${var.template_suffix}.yml",
  )
  count = var.master_count - 1

  vars = {
    reboot_strategy = var.reboot_strategy_master
    vp_manager_context = base64encode(
      element(data.template_file.vp_manager_master.*.rendered, count.index),
    )
    vp_manager_environment_context = base64encode(data.template_file.vp_manager_environment.rendered)
    hosts_context                  = base64encode(data.template_file.hosts_localhost.rendered)
    hugepages_service              = var.mask_hugepages_service
    user_name                      = var.user_name
    user_password                  = var.user_password
    user_pubkey                    = var.user_pubkey
    ssh_trusted_user_ca            = local.ssh_trusted_user_ca
    # physical aws only
    ntp_servers                  = var.ntp_servers
    nic_public                   = var.nic_public
    nic_public_domain            = var.public_name
    nic_fabric                   = var.nic_fabric
    vp_manager_mask_fetch_latest = var.vp_manager_mask_fetch_latest
  }
}

data "template_file" "cloud_config_pool" {
  template = file(
    "${path.module}/resources/cloud-config-pool-${var.template_suffix}.yml",
  )

  vars = {
    reboot_strategy                = var.reboot_strategy_pool
    vp_manager_context             = base64encode(data.template_file.vp_manager_pool.rendered)
    vp_manager_environment_context = base64encode(data.template_file.vp_manager_environment.rendered)
    hosts_context                  = base64encode(data.template_file.hosts_balancer.rendered)
    hugepages_service              = "false"
    user_name                      = var.user_name
    user_password                  = var.user_password
    user_pubkey                    = var.user_pubkey
    ssh_trusted_user_ca            = local.ssh_trusted_user_ca
    # physical aws only
    ntp_servers                  = var.ntp_servers
    nic_public                   = var.nic_public
    nic_fabric                   = var.nic_fabric
    vp_manager_mask_fetch_latest = var.vp_manager_mask_fetch_latest
  }
}