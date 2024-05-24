resource "volterra_token" "site" {
  name      = var.f5xc_token_name
  namespace = var.f5xc_namespace
}

module "maurice" {
  source       = "../../../utils/maurice"
  f5xc_api_url = var.f5xc_api_url
}

module "network_common" {
  source                          = "./network/common"
  gcp_region                      = var.gcp_region
  is_multi_nic                    = local.is_multi_nic
  create_network                  = local.create_network
  create_subnetwork               = local.create_subnetwork
  f5xc_cluster_name               = var.f5xc_cluster_name
  f5xc_is_secure_cloud_ce         = var.f5xc_is_secure_cloud_ce
  gcp_subnet_name_slo             = local.create_subnetwork ? "${var.f5xc_cluster_name}-slo-subnetwork" : null
  gcp_subnet_name_sli             = local.create_subnetwork && local.is_multi_nic ? "${var.f5xc_cluster_name}-sli-subnetwork" : null
  gcp_existing_network_slo        = local.create_network ? null : var.gcp_existing_network_slo
  gcp_existing_network_sli        = local.create_network ? null : var.gcp_existing_network_sli
  gcp_auto_create_subnetworks     = var.gcp_auto_create_subnetworks
  gcp_subnet_ip_cidr_range_slo    = local.create_subnetwork ? var.f5xc_ce_slo_subnet : null
  gcp_subnet_ip_cidr_range_sli    = local.create_subnetwork && local.is_multi_nic ? var.f5xc_ce_sli_subnet : null
  gcp_existing_subnet_network_slo = local.create_subnetwork ? null : var.gcp_existing_subnet_network_slo
  gcp_existing_subnet_network_sli = local.create_subnetwork ? null : var.gcp_existing_subnet_network_sli
}

module "private_ce" {
  source              = "./network/private"
  count               = !var.has_public_ip && var.f5xc_is_private_cloud_ce ? 1 : 0
  gcp_region          = var.gcp_region
  gcp_nat_name        = var.f5xc_private_ce_nat_name
  gcp_project_id      = var.gcp_project_id
  gcp_network_slo     = module.network_common.common["slo_network"]["name"]
  gcp_nat_router_name = var.f5xc_private_ce_nat_router_name
}

module "firewall" {
  source               = "./firewall"
  is_multi_nic         = local.is_multi_nic
  gcp_network_slo      = module.network_common.common["slo_network"]["name"]
  gcp_network_sli      = local.is_multi_nic ? module.network_common.common["sli_network"]["name"] : null
  f5xc_ce_gateway_type = var.f5xc_ce_gateway_type
  f5xc_ce_slo_firewall = var.f5xc_is_secure_cloud_ce ? local.f5xc_secure_ce_slo_firewall : var.f5xc_ce_slo_enable_secure_sg ? local.f5xc_secure_ce_slo_firewall : (length(var.f5xc_ce_slo_firewall.rules) > 0 ? var.f5xc_ce_slo_firewall : local.f5xc_secure_ce_slo_firewall_default)
  f5xc_ce_sli_firewall = local.is_multi_nic ? (var.f5xc_is_secure_cloud_ce ? local.f5xc_secure_ce_sli_firewall : (length(var.f5xc_ce_sli_firewall.rules) > 0 ? var.f5xc_ce_sli_firewall : local.f5xc_secure_ce_sli_firewall_default)) : {
    rules = []
  }
}

module "config" {
  source                       = "./config"
  cluster_name                 = var.f5xc_cluster_name
  cluster_token                = volterra_token.site.id
  cluster_labels               = var.f5xc_cluster_labels
  ssh_public_key               = var.ssh_public_key
  maurice_endpoint             = module.maurice.endpoints.maurice
  maurice_mtls_endpoint        = module.maurice.endpoints.maurice_mtls
  f5xc_ce_gateway_type         = var.f5xc_ce_gateway_type
  f5xc_cluster_latitude        = var.f5xc_cluster_latitude
  f5xc_cluster_longitude       = var.f5xc_cluster_longitude
  f5xc_ce_hosts_public_name    = var.f5xc_ce_hosts_public_name
  f5xc_ce_hosts_public_address = var.f5xc_ce_hosts_public_address
}

module "secure_mesh_site" {
  count                                  = var.f5xc_site_type_is_secure_mesh_site ? 1 : 0
  source                                 = "../../secure_mesh_site"
  csp_provider                           = "gcp"
  f5xc_nodes                             = [for k in keys(var.f5xc_ce_nodes) : { name = k }]
  f5xc_tenant                            = var.f5xc_tenant
  f5xc_api_url                           = var.f5xc_api_url
  f5xc_namespace                         = var.f5xc_namespace
  f5xc_api_token                         = var.f5xc_api_token
  f5xc_cluster_name                      = var.f5xc_cluster_name
  f5xc_cluster_labels = {} # var.f5xc_cluster_labels
  f5xc_ce_gateway_type                   = var.f5xc_ce_gateway_type
  f5xc_cluster_latitude                  = var.f5xc_cluster_latitude
  f5xc_cluster_longitude                 = var.f5xc_cluster_longitude
  f5xc_ce_performance_enhancement_mode   = var.f5xc_ce_performance_enhancement_mode
  f5xc_enable_offline_survivability_mode = var.f5xc_enable_offline_survivability_mode
}

module "node" {
  source                                               = "./nodes"
  gcp_region                                           = var.gcp_region
  is_sensitive                                         = var.is_sensitive
  ssh_username                                         = var.ssh_username
  has_public_ip                                        = var.has_public_ip
  ssh_public_key                                       = var.ssh_public_key
  gcp_instance_type                                    = var.gcp_instance_type
  gcp_instance_tags                                    = var.gcp_instance_tags
  gcp_instance_image                                   = var.gcp_instance_image
  gcp_subnetwork_slo                                   = module.network_common.common["slo_subnetwork"]["name"]
  gcp_subnetwork_sli                                   = local.is_multi_nic ? module.network_common.common["sli_subnetwork"]["name"] : null
  gcp_instance_disk_size                               = var.gcp_instance_disk_size
  gcp_access_config_nat_ip                             = var.gcp_access_config_nat_ip
  gcp_service_account_email                            = var.gcp_service_account_email
  gcp_service_account_scopes                           = var.gcp_service_account_scopes
  gcp_instance_serial_port_enable                      = var.gcp_instance_serial_port_enable
  gcp_instance_template_description                    = var.gcp_instance_template_description
  gcp_instance_template_create_timeout                 = var.gcp_instance_template_create_timeout
  gcp_instance_template_delete_timeout                 = var.gcp_instance_template_delete_timeout
  gcp_instance_group_manager_description               = var.gcp_instance_group_manager_description
  gcp_instance_group_manager_wait_for_instances        = var.gcp_instance_group_manager_wait_for_instances
  gcp_instance_group_manager_base_instance_name        = var.gcp_instance_group_manager_base_instance_name
  gcp_instance_group_manager_distribution_policy_zones = local.f5xc_cluster_node_azs
  f5xc_ce_user_data                                    = module.config.ce["user_data"]
  f5xc_cluster_name                                    = var.f5xc_cluster_name
  f5xc_cluster_size                                    = length(var.f5xc_ce_nodes)
  f5xc_cluster_labels                                  = var.f5xc_cluster_labels
  f5xc_ce_gateway_type                                 = var.f5xc_ce_gateway_type
  f5xc_registration_retry                              = var.f5xc_registration_retry
  f5xc_is_secure_cloud_ce                              = var.f5xc_is_secure_cloud_ce
  f5xc_registration_wait_time                          = var.f5xc_registration_wait_time
}

/*resource "volterra_set_cloud_site_info" "site_info" {
  name        = var.f5xc_cluster_name
  site_type   = "gcp_vpc_site"
  public_ips  = var.f5xc_is_private_cloud_ce ? [module.private_ce.0.ce.nat.address] : var.has_public_ip ? [for node in module.node.ce : node.network_interface[0].access_config[0].nat_ip] : []
  private_ips = [for node in module.node.ce : node.network_interface[0].network_ip]
}*/

module "site_wait_for_online" {
  depends_on                 = [module.node]
  source                     = "../../status/site"
  is_sensitive               = var.is_sensitive
  f5xc_tenant                = var.f5xc_tenant
  f5xc_api_url               = var.f5xc_api_url
  f5xc_api_token             = var.f5xc_api_token
  f5xc_site_name             = var.f5xc_cluster_name
  f5xc_namespace             = var.f5xc_namespace
  f5xc_api_p12_file          = var.f5xc_api_p12_file
  status_check_type          = var.status_check_type
  f5xc_api_p12_cert_password = var.f5xc_api_p12_cert_password
}