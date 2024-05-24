resource "volterra_token" "site" {
  name      = var.f5xc_token_name != "" ? var.f5xc_token_name : var.f5xc_cluster_name
  namespace = var.f5xc_namespace
}

module "maurice" {
  source       = "../../../../utils/maurice"
  f5xc_api_url = var.f5xc_api_url
}

module "network_common" {
  source                          = "./network/common"
  gcp_region                      = var.gcp_region
  create_network                  = local.create_network
  create_subnetwork               = local.create_subnetwork
  f5xc_cluster_name               = var.f5xc_cluster_name
  gcp_subnet_name_slo             = local.create_subnetwork ? "${var.f5xc_cluster_name}-slo-subnetwork" : null
  gcp_existing_network_slo        = local.create_network ? null : var.gcp_existing_network_slo
  gcp_auto_create_subnetworks     = var.gcp_auto_create_subnetworks
  gcp_subnet_ip_cidr_range_slo    = local.create_subnetwork ? var.f5xc_ce_slo_subnet : null
  gcp_existing_subnet_network_slo = local.create_subnetwork ? null : var.gcp_existing_subnet_network_slo
}

module "firewall" {
  source               = "./firewall"
  gcp_network_slo      = module.network_common.common["slo_network"]["name"]
  f5xc_ce_slo_firewall = local.f5xc_ce_slo_firewall_default
}

module "config_master_node" {
  source                    = "./config"
  node_type                 = "master"
  ssh_public_key            = var.ssh_public_key
  f5xc_site_token           = volterra_token.site.id
  f5xc_cluster_name         = var.f5xc_cluster_name
  f5xc_cluster_labels = {}
  f5xc_cluster_latitude     = var.f5xc_cluster_latitude
  f5xc_cluster_longitude    = var.f5xc_cluster_longitude
  f5xc_ce_hosts_public_name = var.f5xc_ce_hosts_public_name
  maurice_endpoint          = module.maurice.endpoints.maurice
  maurice_mtls_endpoint     = module.maurice.endpoints.maurice_mtls
}

module "config_worker_node" {
  source                    = "./config"
  node_type                 = "worker"
  ssh_public_key            = var.ssh_public_key
  f5xc_site_token           = volterra_token.site.id
  f5xc_cluster_name         = var.f5xc_cluster_name
  f5xc_cluster_labels = {}
  f5xc_cluster_latitude     = var.f5xc_cluster_latitude
  f5xc_cluster_longitude    = var.f5xc_cluster_longitude
  f5xc_ce_hosts_public_name = var.f5xc_ce_hosts_public_name
  maurice_endpoint          = module.maurice.endpoints.maurice
  maurice_mtls_endpoint     = module.maurice.endpoints.maurice_mtls
}

module "cluster" {
  source                = "./cluster"
  f5xc_tenant           = var.f5xc_tenant
  f5xc_api_url          = var.f5xc_api_url
  f5xc_api_token        = var.f5xc_api_token
  f5xc_namespace        = var.f5xc_namespace
  f5xc_master_nodes     = [for node in keys(var.f5xc_cluster_nodes.master) : node]
  f5xc_worker_nodes     = [for node in keys(var.f5xc_cluster_nodes.worker) : node]
  f5xc_cluster_name     = var.f5xc_cluster_name
  f5xc_k8s_cluster_name = var.f5xc_cluster_name
}

module "node_master" {
  depends_on                                           = [module.cluster]
  source                                               = "./nodes/master"
  has_public_ip                                        = var.has_public_ip
  is_sensitive                                         = false
  ssh_public_key                                       = var.ssh_public_key
  ssh_username                                         = var.ssh_username
  f5xc_ce_user_data                                    = module.config_master_node.ce["user_data"]
  f5xc_cluster_name                                    = var.f5xc_cluster_name
  f5xc_cluster_size                                    = length(keys(var.f5xc_cluster_nodes.master))
  f5xc_ce_gateway_type                                 = var.f5xc_ce_gateway_type
  f5xc_registration_retry                              = var.f5xc_registration_retry
  f5xc_registration_wait_time                          = var.f5xc_registration_wait_time
  gcp_region                                           = var.gcp_region
  gcp_instance_type                                    = var.gcp_instance_type
  gcp_instance_tags                                    = var.gcp_instance_tags
  gcp_instance_image                                   = var.gcp_instance_image
  gcp_subnetwork_slo                                   = module.network_common.common["slo_subnetwork"]["name"]
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
  gcp_instance_group_manager_distribution_policy_zones = local.f5xc_cluster_master_node_azs
}

module "site_wait_for_online_master" {
  depends_on                 = [module.node_master]
  source                     = "../../../status/site"
  is_sensitive               = var.is_sensitive
  f5xc_tenant                = var.f5xc_tenant
  f5xc_api_url               = var.f5xc_api_url
  f5xc_api_token             = var.f5xc_api_token
  f5xc_namespace             = var.f5xc_namespace
  f5xc_site_name             = var.f5xc_cluster_name
  f5xc_api_p12_file          = var.f5xc_api_p12_file
  status_check_type          = var.status_check_type
  f5xc_api_p12_cert_password = var.f5xc_api_p12_cert_password
}

module "node_worker" {
  depends_on                                           = [module.site_wait_for_online_master]
  source                                               = "./nodes/worker"
  count                                                = length(keys(var.f5xc_cluster_nodes.worker)) > 0 ? 1 : 0
  has_public_ip                                        = var.has_public_ip
  is_sensitive                                         = false
  ssh_public_key                                       = var.ssh_public_key
  ssh_username                                         = var.ssh_username
  f5xc_ce_user_data                                    = module.config_worker_node.ce["user_data"]
  f5xc_cluster_name                                    = var.f5xc_cluster_name
  f5xc_cluster_size                                    = length(keys(var.f5xc_cluster_nodes.worker))
  f5xc_ce_gateway_type                                 = var.f5xc_ce_gateway_type
  f5xc_registration_retry                              = var.f5xc_registration_retry
  f5xc_registration_wait_time                          = var.f5xc_registration_wait_time
  gcp_region                                           = var.gcp_region
  gcp_instance_type                                    = var.gcp_instance_type
  gcp_instance_tags                                    = var.gcp_instance_tags
  gcp_instance_image                                   = var.gcp_instance_image
  gcp_subnetwork_slo                                   = module.network_common.common["slo_subnetwork"]["name"]
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
  gcp_instance_group_manager_distribution_policy_zones = local.f5xc_cluster_worker_node_azs
}

module "site_wait_for_online_worker" {
  depends_on                 = [module.node_worker]
  source                     = "../../../status/site"
  is_sensitive               = var.is_sensitive
  f5xc_tenant                = var.f5xc_tenant
  f5xc_api_url               = var.f5xc_api_url
  f5xc_api_token             = var.f5xc_api_token
  f5xc_namespace             = var.f5xc_namespace
  f5xc_site_name             = var.f5xc_cluster_name
  f5xc_api_p12_file          = var.f5xc_api_p12_file
  status_check_type          = var.status_check_type
  f5xc_api_p12_cert_password = var.f5xc_api_p12_cert_password
}