resource "volterra_token" "site" {
  name      = var.f5xc_token_name
  namespace = var.f5xc_namespace
}

module "network" {
  count                    = local.create_network ? (var.f5xc_ce_gateway_multi_node ? 2 : 1) : 0
  source                   = "./network"
  gcp_region               = var.gcp_region
  is_multi_nic             = local.is_multi_nic
  project_name             = var.project_name
  auto_create_subnetworks  = var.auto_create_subnetworks
  subnet_slo_ip_cidr_range = var.subnet_slo_ip_cidr_range
  subnet_sli_ip_cidr_range = var.subnet_sli_ip_cidr_range
  f5xc_is_secure_cloud_ce  = var.f5xc_is_secure_cloud_ce
}

module "firewall" {
  source               = "./firewall"
  sli_network          = local.is_multi_nic && var.subnet_sli_ip_cidr_range != "" ? module.network[0].ce["sli_subnetwork"]["id"] : var.existing_network_inside.network_name
  slo_network          = var.subnet_slo_ip_cidr_range != "" ? module.network[0].ce["slo_subnetwork"]["id"] : var.existing_network_outside.network_name
  f5xc_ce_gateway_type = var.f5xc_ce_gateway_type
  f5xc_ce_sli_firewall = local.is_multi_nic ? (var.f5xc_is_secure_cloud_ce ? local.f5xc_secure_ce_sli_firewall : (length(var.f5xc_ce_sli_firewall) > 0 ? var.f5xc_ce_sli_firewall : var.f5xc_ce_sli_default_firewall)) : null
  f5xc_ce_slo_firewall = var.f5xc_is_secure_cloud_ce ? local.f5xc_secure_ce_slo_firewall : (length(var.f5xc_ce_slo_firewall) > 0 ? var.f5xc_ce_slo_firewall : var.f5xc_ce_slo_default_firewall)
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
  is_sensitive                = var.is_sensitive
  machine_type                = var.machine_type
  ssh_username                = var.ssh_username
  has_public_ip               = var.has_public_ip
  instance_tags               = var.instance_tags
  machine_image               = var.machine_image
  instance_name               = var.instance_name
  sli_subnetwork              = local.is_multi_nic && var.subnet_sli_ip_cidr_range != "" ? module.network[0].ce["master-${count.index}"]["sli_subnetwork"] : var.existing_network_inside.subnets_ids[0]
  slo_subnetwork              = var.subnet_slo_ip_cidr_range != "" ? module.network[0].ce["master-${count.index}"]["slo_subnetwork"] : var.existing_network_outside.subnets_ids[0]
  ssh_public_key              = var.ssh_public_key
  machine_disk_size           = var.machine_disk_size
  access_config_nat_ip        = var.access_config_nat_ip
  allow_stopping_for_update   = var.allow_stopping_for_update
  gcp_service_account_email   = var.gcp_service_account_email
  gcp_service_account_scopes  = var.gcp_service_account_scopes
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
