resource "volterra_token" "site" {
  name      = var.f5xc_token_name
  namespace = var.f5xc_namespace
}

module "network_common" {
  count                   = local.create_network ? 1 : 0
  source                  = "./network/common"
  is_multi_nic            = local.is_multi_nic
  f5xc_cluster_name       = var.f5xc_cluster_name
  auto_create_subnetworks = var.auto_create_subnetworks
  f5xc_is_secure_cloud_ce = var.f5xc_is_secure_cloud_ce
}

module "network_node" {
  for_each                 = {for k, v in var.f5xc_ce_nodes : k=>v}
  source                   = "./network/node"
  gcp_region               = var.gcp_region
  is_multi_nic             = local.is_multi_nic
  slo_subnet_name          = "${var.f5xc_cluster_name}-${each.key}-slo-subnetwork"
  sli_subnet_name          = "${var.f5xc_cluster_name}-${each.key}-sli-subnetwork"
  slo_vpc_network_id       = local.create_network ? module.network_common[0].common["slo_network"]["id"] : var.existing_network_outside["network_id"]
  sli_vpc_network_id       = local.is_multi_nic ? local.create_network ? module.network_common[0].common["sli_network"]["id"] : var.existing_network_inside["network_id"] : ""
  subnet_slo_ip_cidr_range = var.f5xc_ce_nodes[each.key].slo_subnet
  subnet_sli_ip_cidr_range = local.is_multi_nic ? var.f5xc_ce_nodes[each.key].sli_subnet : ""
}

module "firewall" {
  source               = "./firewall"
  count                = local.create_network ? 1 : 0
  is_multi_nic         = local.is_multi_nic
  sli_network          = local.is_multi_nic ? local.create_network ? module.network_common[0].common["sli_network"]["name"] : var.existing_network_inside["network_name"] : ""
  slo_network          = local.create_network ? module.network_common[0].common["slo_network"]["name"] : var.existing_network_outside["network_name"]
  f5xc_ce_gateway_type = var.f5xc_ce_gateway_type
  f5xc_ce_sli_firewall = local.is_multi_nic ? (var.f5xc_is_secure_cloud_ce ? local.f5xc_secure_ce_sli_firewall : (length(var.f5xc_ce_sli_firewall.rules) > 0 ? var.f5xc_ce_sli_firewall : local.f5xc_secure_ce_sli_firewall_default)) : {
    rules = []
  }
  f5xc_ce_slo_firewall = var.f5xc_is_secure_cloud_ce ? local.f5xc_secure_ce_slo_firewall : (length(var.f5xc_ce_slo_firewall.rules) > 0 ? var.f5xc_ce_slo_firewall : local.f5xc_secure_ce_slo_firewall_default)
}

module "config" {
  source                     = "./config"
  for_each                   = {for k, v in var.f5xc_ce_nodes : k=>v}
  cluster_name               = var.f5xc_cluster_name
  volterra_token             = volterra_token.site.id
  cluster_labels             = var.f5xc_cluster_labels
  ssh_public_key             = var.ssh_public_key
  host_localhost_public_name = var.host_localhost_public_name
  f5xc_ce_gateway_type       = var.f5xc_ce_gateway_type
  f5xc_cluster_latitude      = var.f5xc_cluster_latitude
  f5xc_cluster_longitude     = var.f5xc_cluster_longitude
}

module "node" {
  source                      = "./nodes"
  for_each                    = {for k, v in var.f5xc_ce_nodes : k=>v}
  is_sensitive                = var.is_sensitive
  ssh_username                = var.ssh_username
  instance_type               = var.instance_type
  has_public_ip               = var.has_public_ip
  instance_tags               = var.instance_tags
  instance_image              = var.instance_image
  availability_zone           = var.f5xc_ce_nodes[each.key].az
  sli_subnetwork              = local.create_network && local.is_multi_nic ? module.network_node[each.key].ce["sli_subnetwork"]["name"] : local.is_multi_nic ? var.existing_network_inside.subnets_ids[0] : ""
  slo_subnetwork              = local.create_network ? module.network_node[each.key].ce["slo_subnetwork"]["name"] : var.existing_network_outside.subnets_ids[0]
  ssh_public_key              = var.ssh_public_key
  instance_disk_size          = var.instance_disk_size
  access_config_nat_ip        = var.access_config_nat_ip
  allow_stopping_for_update   = var.allow_stopping_for_update
  gcp_service_account_email   = var.gcp_service_account_email
  gcp_service_account_scopes  = var.gcp_service_account_scopes
  f5xc_tenant                 = var.f5xc_tenant
  f5xc_api_url                = var.f5xc_api_url
  f5xc_api_token              = var.f5xc_api_token
  f5xc_namespace              = var.f5xc_namespace
  f5xc_node_name              = format("%s-%s", var.f5xc_cluster_name, each.key)
  f5xc_ce_user_data           = module.config[each.key].ce["user_data"]
  f5xc_cluster_name           = var.f5xc_cluster_name
  f5xc_cluster_size           = length(var.f5xc_ce_nodes)
  f5xc_cluster_labels         = var.f5xc_cluster_labels
  f5xc_ce_gateway_type        = var.f5xc_ce_gateway_type
  f5xc_registration_retry     = var.f5xc_registration_retry
  f5xc_registration_wait_time = var.f5xc_registration_wait_time
}

module "site_wait_for_online" {
  depends_on     = [module.node]
  source         = "../../status/site"
  f5xc_api_token = var.f5xc_api_token
  f5xc_api_url   = var.f5xc_api_url
  f5xc_namespace = var.f5xc_namespace
  f5xc_site_name = var.f5xc_cluster_name
  f5xc_tenant    = var.f5xc_tenant
  is_sensitive   = var.is_sensitive
}