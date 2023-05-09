resource "volterra_token" "token" {
  name      = var.f5xc_cluster_name
  namespace = var.f5xc_namespace
}

resource "azurerm_resource_group" "rg" {
  count    = var.f5xc_existing_azure_resource_group != "" ? 0 : 1
  name     = format("%s-rg", var.f5xc_cluster_name)
  location = var.f5xc_azure_region
}

module "secure_ce_security_rules" {
  source                         = "./network/sgr"
  count                          = var.f5xc_is_secure_cloud_ce ? 1 : 0
  azure_security_group_rules_slo = local.azure_security_group_rules_slo_secure_ce
  azure_security_group_rules_sli = local.is_multi_nic ? local.azure_security_group_rules_sli_secure_ce : []
}

module "ce_default_security_rules" {
  source                         = "./network/sgr"
  azure_security_group_rules_slo = local.azure_security_group_rules_slo_default
  azure_security_group_rules_sli = local.is_multi_nic ? local.azure_security_group_rules_sli_default : []
}

module "maurice" {
  source       = "../../../utils/maurice"
  f5xc_api_url = var.f5xc_api_url
}

module "network_common" {
  source                        = "./network/common"
  common_tags                   = local.common_tags
  is_multi_nic                  = local.is_multi_nic
  f5xc_azure_region             = var.f5xc_azure_region
  f5xc_cluster_name             = var.f5xc_cluster_name
  azurerm_vnet_address_space    = var.azurerm_vnet_address_space
  azurerm_existing_vnet_name    = var.azurerm_existing_vnet_name
  azurerm_resource_group_name   = local.f5xc_azure_resource_group
  azurerm_security_group_sli_id = local.is_multi_nic ? (var.f5xc_is_secure_cloud_ce ? concat(var.azure_security_group_rules_sli, module.secure_ce_security_rules[0].sgr["security_group_rules_sli"]) : ((var.f5xc_is_secure_cloud_ce == false && length(var.azure_security_group_rules_sli) > 0 ? var.azure_security_group_rules_sli : module.ce_default_security_rules.sgr["security_group_rules_sli"]))) : []
  azurerm_security_group_slo_id = var.f5xc_is_secure_cloud_ce ? concat(module.secure_ce_security_rules[0].sgr["security_group_rules_slo"], var.azure_security_group_rules_slo) : (var.f5xc_is_secure_cloud_ce == false && length(var.azure_security_group_rules_slo) > 0 ? var.azure_security_group_rules_slo : module.ce_default_security_rules.sgr["security_group_rules_slo"])
}

module "network_node" {
  source                            = "./network/node"
  for_each                          = var.f5xc_azure_az_nodes
  is_multi_nic                      = local.is_multi_nic
  has_public_ip                     = var.has_public_ip
  azurerm_vnet_name                 = module.network_common.common["vnet"]["name"]
  azurerm_resource_group_name       = local.f5xc_azure_resource_group
  azurerm_security_group_slo_id     = module.network_common.common["sg_slo"]["id"]
  azurerm_security_group_sli_id     = local.is_multi_nic ? module.network_common.common["sg_sli"]["id"] : ""
  azurerm_route_table_next_hop_type = var.azurerm_route_table_next_hop_type
  azurerm_subnet_slo_address_prefix = each.value["f5xc_azure_vnet_slo_subnet"]
  azurerm_subnet_sli_address_prefix = local.is_multi_nic ? each.value["f5xc_azure_vnet_sli_subnet"] : ""
  f5xc_node_name                    = format("%s-%s", var.f5xc_cluster_name, each.key)
  f5xc_azure_region                 = var.f5xc_azure_region
}

module "secure_ce_node" {
  source                        = "./network/secure/node"
  for_each                      = var.f5xc_is_secure_cloud_ce ? var.f5xc_azure_az_nodes : {}
  is_multi_nic                  = local.is_multi_nic
  f5xc_azure_region             = var.f5xc_azure_region
  f5xc_cluster_name             = var.f5xc_cluster_name
  f5xc_secure_ce_zones          = var.f5xc_secure_cloud_ce_zones
  azurerm_resource_group_name   = local.f5xc_azure_resource_group
  azurerm_nat_gateway_subnet_id = module.network_node[each.key].ce["slo_subnet"]["id"]
}

module "nlb_common" {
  source                               = "./network/nlb/common"
  count                                = local.is_multi_node ? 1 : 0
  is_multi_nic                         = local.is_multi_nic
  azurerm_resource_group_name          = local.f5xc_azure_resource_group
  azurerm_lb_frontend_ip_configuration = [
    for node in module.network_node :
    {
      name      = "slo"
      subnet_id = node.ce["slo_subnet"]["id"]
    }
  ]
  f5xc_azure_region                = var.f5xc_azure_region
  f5xc_cluster_name                = var.f5xc_cluster_name
  f5xc_azure_az_nodes              = var.f5xc_azure_az_nodes
  f5xc_site_set_vip_info_namespace = var.f5xc_namespace
}

module "nlb_node" {
  source                              = "./network/nlb/node"
  for_each                            = local.is_multi_node ? {for k, v in var.f5xc_azure_az_nodes : k=>v} : {}
  is_multi_nic                        = local.is_multi_nic
  f5xc_node_name                      = format("%s-%s", var.f5xc_cluster_name, each.key)
  azurerm_network_interface_slo_id    = module.network_node[each.key].ce["slo"]["id"]
  azurerm_network_interface_sli_id    = local.is_multi_nic ? module.network_node[each.key].ce["sli"]["id"] : null
  azurerm_backend_address_pool_id_slo = module.nlb_common[0].common["backend_address_pool_slo"]["id"]
  azurerm_backend_address_pool_id_sli = local.is_multi_nic ?  module.nlb_common[0].common["backend_address_pool_sli"]["id"] : null
}

module "config" {
  source                      = "./config"
  for_each                    = {for k, v in var.f5xc_azure_az_nodes : k=>v}
  f5xc_azure_region           = var.f5xc_azure_region
  f5xc_cluster_name           = var.f5xc_cluster_name
  f5xc_cluster_labels         = var.f5xc_cluster_labels
  f5xc_cluster_latitude       = var.f5xc_cluster_latitude
  f5xc_cluster_longitude      = var.f5xc_cluster_longitude
  f5xc_registration_token     = volterra_token.token.id
  f5xc_ce_hosts_public_name   = var.f5xc_ce_hosts_public_name
  azurerm_vnet_name           = var.azurerm_existing_vnet_name != "" ? var.azurerm_existing_vnet_name : format("%s-vnet", var.f5xc_cluster_name)
  azurerm_tenant_id           = var.azurerm_tenant_id
  azurerm_client_id           = var.azurerm_client_id
  azurerm_client_secret       = var.azurerm_client_secret
  azurerm_resource_group      = local.f5xc_azure_resource_group
  azurerm_subscription_id     = var.azurerm_subscription_id
  azurerm_vnet_subnet_name    = module.network_node[each.key].ce["slo_subnet"]["name"]
  azurerm_vnet_resource_group = local.f5xc_azure_resource_group
  owner_tag                   = var.owner_tag
  is_multi_nic                = local.is_multi_nic
  ssh_public_key              = var.ssh_public_key
  maurice_endpoint            = module.maurice.endpoints.maurice
  maurice_mtls_endpoint       = module.maurice.endpoints.maurice_mtls
}

module "node" {
  source                                 = "./nodes"
  for_each                               = {for k, v in var.f5xc_azure_az_nodes : k=>v}
  azurerm_marketplace_plan               = var.f5xc_azure_marketplace_agreement_plans[var.f5xc_ce_gateway_type]
  azurerm_instance_vm_size               = var.azurerm_instance_vm_size
  azurerm_marketplace_offer              = var.f5xc_azure_marketplace_agreement_offers[var.f5xc_ce_gateway_type]
  azurerm_instance_disk_size             = var.azurerm_instance_disk_size
  azurerm_resource_group_name            = local.f5xc_azure_resource_group
  azurerm_availability_set_id            = var.azurerm_availability_set_id
  azurerm_marketplace_version            = var.azurerm_marketplace_version
  azurerm_marketplace_publisher          = var.f5xc_azure_marketplace_agreement_publisher
  azurerm_instance_admin_username        = var.azurerm_instance_admin_username
  azurerm_primary_network_interface_id   = module.network_node[each.key].ce["slo"]["id"]
  azurerm_instance_network_interface_ids = module.network_node[each.key].ce["interface_ids"]
  f5xc_tenant                            = var.f5xc_tenant
  f5xc_api_url                           = var.f5xc_api_url
  f5xc_namespace                         = var.f5xc_namespace
  f5xc_api_token                         = var.f5xc_api_token
  f5xc_node_name                         = format("%s-%s", var.f5xc_cluster_name, each.key)
  f5xc_azure_region                      = var.f5xc_azure_region
  f5xc_cluster_name                      = var.f5xc_cluster_name
  f5xc_cluster_size                      = length(var.f5xc_azure_az_nodes)
  f5xc_instance_config                   = module.config[each.key].ce["user_data"]
  f5xc_registration_retry                = var.f5xc_registration_retry
  f5xc_registration_wait_time            = var.f5xc_registration_wait_time
  owner_tag                              = var.owner_tag
  common_tags                            = local.common_tags
  ssh_public_key                         = var.ssh_public_key
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