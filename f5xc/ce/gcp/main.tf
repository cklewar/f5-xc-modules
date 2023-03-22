resource "volterra_token" "site" {
  name      = var.f5xc_token_name
  namespace = var.f5xc_namespace
}

locals {
  create_network = var.fabric_subnet_outside != "" || (var.fabric_subnet_inside != "" && var.fabric_subnet_outside != "") ? true : false
}

module "network" {
  count                 = local.create_network ? (var.f5xc_ce_gateway_multi_node ? 2 : 1) : 0
  source                = "./network"
  gcp_region            = var.gcp_region
  network_name          = var.network_name
  fabric_subnet_outside = var.fabric_subnet_outside
  fabric_subnet_inside  = var.fabric_subnet_inside
  f5xc_ce_gateway_type  = var.f5xc_ce_gateway_type
}

module "config" {
  count                      = var.f5xc_ce_gateway_multi_node ? 2 : 1
  source                     = "./config"
  instance_name              = var.instance_name
  volterra_token             = volterra_token.site.id
  cluster_labels             = local.cluster_labels
  ssh_public_key             = var.ssh_public_key
  host_localhost_public_name = var.host_localhost_public_name
  f5xc_ce_gateway_type       = var.f5xc_ce_gateway_type
  f5xc_cluster_latitude      = var.f5xc_cluster_latitude
  f5xc_cluster_longitude     = var.f5xc_cluster_longitude
}

module "node" {
  count                       = var.f5xc_ce_gateway_multi_node ? 2 : 1
  source                      = "./nodes"
  machine_type                = var.machine_type
  ssh_username                = var.ssh_username
  machine_image               = var.machine_image
  instance_name               = var.instance_name
  sli_subnetwork              = var.fabric_subnet_inside != "" ? module.network[0].ce["master-${count.index}"]["sli_subnetwork"] : var.existing_fabric_subnet_inside
  slo_subnetwork              = var.fabric_subnet_outside != "" ? module.network[0].ce["master-${count.index}"]["slo_subnetwork"] : var.existing_fabric_subnet_outside
  ssh_public_key              = var.ssh_public_key
  machine_disk_size           = var.machine_disk_size
  f5xc_tenant                 = var.f5xc_tenant
  f5xc_api_url                = var.f5xc_api_url
  f5xc_api_token              = var.f5xc_api_token
  f5xc_namespace              = var.f5xc_namespace
  f5xc_ce_user_data           = module.config[0].ce["master-${count.index}"]["user_data"]
  f5xc_cluster_size           = var.f5xc_cluster_size
  f5xc_ce_gateway_type        = var.f5xc_ce_gateway_type
  f5xc_registration_retry     = var.f5xc_registration_retry
  f5xc_registration_wait_time = var.f5xc_registration_wait_time
}