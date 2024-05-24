resource "volterra_token" "token" {
  name      = var.f5xc_token_name != "" ? var.f5xc_token_name : var.f5xc_cluster_name
  namespace = var.f5xc_namespace
}

resource "azurerm_resource_group" "rg" {
  count    = var.azurerm_existing_resource_group_name != "" ? 0 : 1
  name     = format("%s-rg", var.f5xc_cluster_name)
  location = var.azurerm_region
}

module "ce_default_security_rules" {
  source                         = "./network/sgr"
  azure_security_group_rules_slo = local.azure_security_group_rules_slo_default
}

module "maurice" {
  source       = "../../../../utils/maurice"
  f5xc_api_url = var.f5xc_api_url
}

module "network_common" {
  source                        = "./network/common"
  common_tags                   = local.common_tags
  azurerm_region                = var.azurerm_region
  f5xc_cluster_name             = var.f5xc_cluster_name
  azurerm_vnet_address_space    = var.azurerm_vnet_address_space
  azurerm_existing_vnet_name    = var.azurerm_existing_vnet_name
  azurerm_resource_group_name   = local.f5xc_azure_resource_group
  azurerm_security_group_slo_id = length(var.azurerm_security_group_rules_slo) > 0 ? var.azurerm_security_group_rules_slo : module.ce_default_security_rules.sgr["security_group_rules_slo"]
}

module "network_master_node" {
  source                            = "./network/node"
  for_each                          = {for k, v in var.f5xc_cluster_nodes.master : k => v}
  has_public_ip                     = var.has_public_ip
  f5xc_node_name                    = format("%s-%s", var.f5xc_cluster_name, each.key)
  azurerm_zone                      = var.azurerm_availability_set_id == "" ? each.value["az"] : ""
  azurerm_region                    = var.azurerm_region
  azurerm_vnet_name                 = module.network_common.common["vnet"]["name"]
  azurerm_resource_group_name       = local.f5xc_azure_resource_group
  azurerm_security_group_slo_id     = module.network_common.common["sg_slo"]["id"]
  azurerm_existing_subnet_name_slo  = contains(keys(var.f5xc_cluster_nodes.master[each.key]), "existing_subnet_name_slo") ? each.value["existing_subnet_name_slo"] : null
  azurerm_route_table_next_hop_type = var.azurerm_route_table_next_hop_type
  azurerm_subnet_slo_address_prefix = contains(keys(each.value), "subnet_slo") ? each.value["subnet_slo"] : ""
}

module "network_worker_node" {
  source                            = "./network/node"
  for_each                          = {for k, v in var.f5xc_cluster_nodes.worker : k => v}
  has_public_ip                     = var.has_public_ip
  f5xc_node_name                    = format("%s-%s", var.f5xc_cluster_name, each.key)
  azurerm_zone                      = var.azurerm_availability_set_id == "" ? each.value["az"] : ""
  azurerm_region                    = var.azurerm_region
  azurerm_vnet_name                 = module.network_common.common["vnet"]["name"]
  azurerm_resource_group_name       = local.f5xc_azure_resource_group
  azurerm_security_group_slo_id     = module.network_common.common["sg_slo"]["id"]
  azurerm_existing_subnet_name_slo  = contains(keys(var.f5xc_cluster_nodes.worker[each.key]), "existing_subnet_name_slo") ? each.value["existing_subnet_name_slo"] : null
  azurerm_route_table_next_hop_type = var.azurerm_route_table_next_hop_type
  azurerm_subnet_slo_address_prefix = contains(keys(each.value), "subnet_slo") ? each.value["subnet_slo"] : ""
}

module "config_master_node" {
  source                          = "./config"
  for_each                        = {for k, v in var.f5xc_cluster_nodes.master : k => v}
  owner_tag                       = var.owner_tag
  node_type                       = "master"
  ssh_public_key                  = var.ssh_public_key
  maurice_endpoint                = module.maurice.endpoints.maurice
  maurice_mtls_endpoint           = module.maurice.endpoints.maurice_mtls
  f5xc_cluster_name               = var.f5xc_cluster_name
  f5xc_cluster_labels             = var.f5xc_cluster_labels
  f5xc_cluster_latitude           = var.f5xc_cluster_latitude
  f5xc_cluster_longitude          = var.f5xc_cluster_longitude
  f5xc_registration_token         = volterra_token.token.id
  f5xc_ce_hosts_public_name       = var.f5xc_ce_hosts_public_name
  azurerm_region                  = var.azurerm_region
  azurerm_vnet_name               = var.azurerm_existing_vnet_name != "" ? var.azurerm_existing_vnet_name : format("%s-vnet", var.f5xc_cluster_name)
  azurerm_tenant_id               = var.azurerm_tenant_id
  azurerm_client_id               = var.azurerm_client_id
  azurerm_client_secret           = var.azurerm_client_secret
  azurerm_resource_group          = local.f5xc_azure_resource_group
  azurerm_subscription_id         = var.azurerm_subscription_id
  azurerm_vnet_subnet_name        = module.network_master_node[each.key].ce["slo_subnet"]["name"]
  azurerm_vnet_resource_group     = local.f5xc_azure_resource_group
  azurerm_instance_admin_username = var.azurerm_instance_admin_username
}

module "config_worker_node" {
  source                          = "./config"
  for_each                        = {for k, v in var.f5xc_cluster_nodes.worker : k => v}
  owner_tag                       = var.owner_tag
  node_type                       = "worker"
  ssh_public_key                  = var.ssh_public_key
  maurice_endpoint                = module.maurice.endpoints.maurice
  maurice_mtls_endpoint           = module.maurice.endpoints.maurice_mtls
  f5xc_cluster_name               = var.f5xc_cluster_name
  f5xc_cluster_labels             = var.f5xc_cluster_labels
  f5xc_cluster_latitude           = var.f5xc_cluster_latitude
  f5xc_cluster_longitude          = var.f5xc_cluster_longitude
  f5xc_registration_token         = volterra_token.token.id
  f5xc_ce_hosts_public_name       = var.f5xc_ce_hosts_public_name
  azurerm_region                  = var.azurerm_region
  azurerm_vnet_name               = var.azurerm_existing_vnet_name != "" ? var.azurerm_existing_vnet_name : format("%s-vnet", var.f5xc_cluster_name)
  azurerm_tenant_id               = var.azurerm_tenant_id
  azurerm_client_id               = var.azurerm_client_id
  azurerm_client_secret           = var.azurerm_client_secret
  azurerm_resource_group          = local.f5xc_azure_resource_group
  azurerm_subscription_id         = var.azurerm_subscription_id
  azurerm_vnet_subnet_name        = module.network_worker_node[each.key].ce["slo_subnet"]["name"]
  azurerm_vnet_resource_group     = local.f5xc_azure_resource_group
  azurerm_instance_admin_username = var.azurerm_instance_admin_username
}

module "cluster" {
  source                = "../../../voltstack_site"
  csp_provider          = "azure"
  f5xc_tenant           = var.f5xc_tenant
  f5xc_api_url          = var.f5xc_api_url
  f5xc_api_token        = var.f5xc_api_token
  f5xc_namespace        = var.f5xc_namespace
  f5xc_master_nodes     = [for node in keys(var.f5xc_cluster_nodes.master) : node]
  f5xc_worker_nodes     = [for node in keys(var.f5xc_cluster_nodes.worker) : node]
  f5xc_cluster_name     = var.f5xc_cluster_name
  f5xc_ce_gateway_type  = var.f5xc_ce_gateway_type
  f5xc_k8s_cluster_name = var.f5xc_cluster_name
}

module "node_master" {
  source                                  = "./nodes"
  for_each                                = {for k, v in var.f5xc_cluster_nodes.master : k => v}
  owner_tag                               = var.owner_tag
  common_tags                             = local.common_tags
  ssh_public_key                          = var.ssh_public_key
  azurerm_az                              = var.azurerm_availability_set_id == "" ? contains(keys(var.f5xc_cluster_nodes.master[each.key]), "az") ? var.f5xc_cluster_nodes.master[each.key]["az"] : null : null
  azurerm_region                          = var.azurerm_region
  azurerm_marketplace_plan                = var.f5xc_azure_marketplace_agreement_plans[var.f5xc_ce_gateway_type]
  azurerm_instance_vm_size                = var.azurerm_instance_vm_size
  azurerm_marketplace_offer               = var.f5xc_azure_marketplace_agreement_offers[var.f5xc_ce_gateway_type]
  azurerm_instance_disk_size              = var.azurerm_instance_disk_size
  azurerm_resource_group_name             = local.f5xc_azure_resource_group
  azurerm_availability_set_id             = var.azurerm_availability_set_id
  azurerm_marketplace_version             = var.azurerm_marketplace_version
  azurerm_marketplace_publisher           = var.f5xc_azure_marketplace_agreement_publisher
  azurerm_instance_admin_username         = var.azurerm_instance_admin_username
  azurerm_instance_admin_password         = var.azurerm_instance_admin_password
  azurerm_os_disk_storage_account_type    = var.azurerm_os_disk_storage_account_type
  azurerm_primary_network_interface_id    = module.network_master_node[each.key].ce["slo"]["id"]
  azurerm_instance_network_interface_ids  = module.network_master_node[each.key].ce["interface_ids"]
  azurerm_disable_password_authentication = var.azurerm_disable_password_authentication
  f5xc_tenant                             = var.f5xc_tenant
  f5xc_api_url                            = var.f5xc_api_url
  f5xc_namespace                          = var.f5xc_namespace
  f5xc_api_token                          = var.f5xc_api_token
  f5xc_node_name                          = format("%s-%s", var.f5xc_cluster_name, each.key)
  f5xc_cluster_name                       = var.f5xc_cluster_name
  f5xc_cluster_size                       = length(var.f5xc_cluster_nodes.master)
  f5xc_instance_config                    = module.config_master_node[each.key].ce["user_data"]
  f5xc_registration_retry                 = var.f5xc_registration_retry
  f5xc_registration_wait_time             = var.f5xc_registration_wait_time
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
  depends_on                              = [module.node_master]
  source                                  = "./nodes"
  for_each                                = {for k, v in var.f5xc_cluster_nodes.worker : k => v}
  owner_tag                               = var.owner_tag
  common_tags                             = local.common_tags
  ssh_public_key                          = var.ssh_public_key
  azurerm_az                              = var.azurerm_availability_set_id == "" ? contains(keys(var.f5xc_cluster_nodes.worker[each.key]), "az") ? var.f5xc_cluster_nodes.worker[each.key]["az"] : null : null
  azurerm_region                          = var.azurerm_region
  azurerm_marketplace_plan                = var.f5xc_azure_marketplace_agreement_plans[var.f5xc_ce_gateway_type]
  azurerm_instance_vm_size                = var.azurerm_instance_vm_size
  azurerm_marketplace_offer               = var.f5xc_azure_marketplace_agreement_offers[var.f5xc_ce_gateway_type]
  azurerm_instance_disk_size              = var.azurerm_instance_disk_size
  azurerm_resource_group_name             = local.f5xc_azure_resource_group
  azurerm_availability_set_id             = var.azurerm_availability_set_id
  azurerm_marketplace_version             = var.azurerm_marketplace_version
  azurerm_marketplace_publisher           = var.f5xc_azure_marketplace_agreement_publisher
  azurerm_instance_admin_username         = var.azurerm_instance_admin_username
  azurerm_instance_admin_password         = var.azurerm_instance_admin_password
  azurerm_os_disk_storage_account_type    = var.azurerm_os_disk_storage_account_type
  azurerm_primary_network_interface_id    = module.network_worker_node[each.key].ce["slo"]["id"]
  azurerm_instance_network_interface_ids  = module.network_worker_node[each.key].ce["interface_ids"]
  azurerm_disable_password_authentication = var.azurerm_disable_password_authentication
  f5xc_tenant                             = var.f5xc_tenant
  f5xc_api_url                            = var.f5xc_api_url
  f5xc_namespace                          = var.f5xc_namespace
  f5xc_api_token                          = var.f5xc_api_token
  f5xc_node_name                          = format("%s-%s", var.f5xc_cluster_name, each.key)
  f5xc_cluster_name                       = var.f5xc_cluster_name
  f5xc_cluster_size                       = length(var.f5xc_cluster_nodes.worker)
  f5xc_instance_config                    = module.config_worker_node[each.key].ce["user_data"]
  f5xc_registration_retry                 = var.f5xc_registration_retry
  f5xc_registration_wait_time             = var.f5xc_registration_wait_time
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