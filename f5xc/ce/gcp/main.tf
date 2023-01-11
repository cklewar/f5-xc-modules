resource "volterra_token" "site" {
  name      = var.f5xc_token_name
  namespace = var.f5xc_namespace
  provider  = volterra.default
}

module "network" {
  source               = "./network"
  network_name         = var.network_name
  gcp_region           = var.gcp_region
  fabric_subnet_public = var.fabric_subnet_public
  fabric_subnet_inside = var.fabric_subnet_inside
}

module "config" {
  source                 = "./config"
  public_name            = "vip"
  instance_name          = var.instance_name
  volterra_token         = volterra_token.site.id
  cluster_labels         = local.cluster_labels
  ssh_public_key         = var.ssh_public_key
  f5xc_ce_gateway_type   = "ingress_egress_gateway"
  f5xc_cluster_latitude  = var.f5xc_cluster_latitude
  f5xc_cluster_longitude = var.f5xc_cluster_longitude
}

module "node" {
  source                      = "./node"
  user_data                   = module.config.ce["user_data"]
  machine_type                = var.machine_type
  cluster_size                = var.cluster_size
  ssh_username                = var.ssh_username
  machine_image               = var.machine_image
  instance_name               = var.instance_name
  sli_subnetwork              = module.network.ce["sli_subnetwork"]
  slo_subnetwork              = module.network.ce["slo_subnetwork"]
  ssh_public_key              = var.ssh_public_key
  machine_disk_size           = var.machine_disk_size
  f5xc_tenant                 = var.f5xc_tenant
  f5xc_api_url                = var.f5xc_api_url
  f5xc_api_token              = var.f5xc_api_token
  f5xc_namespace              = var.f5xc_namespace
  f5xc_registration_retry     = var.f5xc_registration_retry
  f5xc_registration_wait_time = var.f5xc_registration_wait_time
}