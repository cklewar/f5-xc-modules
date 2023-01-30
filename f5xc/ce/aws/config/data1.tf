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