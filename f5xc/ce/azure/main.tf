resource "azurerm_marketplace_agreement" "ce" {
  publisher = var.f5xc_azure_marketplace_agreement_publisher
  offer     = var.f5xc_azure_marketplace_agreement_offers[var.f5xc_ce_gateway_type]
  plan      = var.f5xc_azure_marketplace_agreement_plans[var.f5xc_ce_gateway_type]
}

resource "azurerm_resource_group" "rg" {
  count    = var.f5xc_existing_azure_resource_group != "" ? 0 : 1
  location = var.f5xc_azure_region
  name     = format("%s-rg", var.f5xc_cluster_name)
}

module "network_common" {
  source                                   = "./network/common"
  common_tags                              = local.common_tags
  is_multi_nic                             = local.is_multi_nic
  azurerm_vnet_address_space               = var.azurerm_vnet_address_space
  azurerm_resource_group_name              = local.f5xc_azure_resource_group
  azure_linux_security_sli_rules           = local.is_multi_nic ? (length(var.azure_security_group_rules_sli) > 0 ? var.azure_security_group_rules_sli : var.azure_security_group_rules_sli_default) : []
  azure_linux_security_slo_rules           = length(var.azure_security_group_rules_slo) > 0 ? var.azure_security_group_rules_slo : (var.f5xc_is_secure_cloud_ce == false ? var.azure_security_group_rules_slo_default : [])
  azure_linux_security_sli_rules_secure_ce = local.is_multi_nic && var.f5xc_is_secure_cloud_ce ? local.azure_security_group_rules_sli_secure_ce : null
  azure_linux_security_slo_rules_secure_ce = var.f5xc_is_secure_cloud_ce ? local.azure_security_group_rules_slo_secure_ce : null
  azurerm_existing_virtual_network_name    = var.azurerm_existing_virtual_network_name
  f5xc_azure_region                        = var.f5xc_azure_region
  f5xc_cluster_name                        = var.f5xc_cluster_name
  f5xc_is_secure_cloud_ce                  = var.f5xc_is_secure_cloud_ce
}

module "secure_ce" {
  source                        = "./network/secure"
  for_each                      = var.f5xc_is_secure_cloud_ce ? {for k, v in var.f5xc_azure_az_nodes : k=>v} : {}
  f5xc_azure_region             = var.f5xc_azure_region
  f5xc_cluster_name             = var.f5xc_cluster_name
  azurerm_resource_group_name   = local.f5xc_azure_resource_group
  azurerm_nat_gateway_subnet_id = module.network_node[each.key].ce["slo_subnet"]["id"]
}

module "network_node" {
  source                                  = "./network/node"
  for_each                                = {for k, v in var.f5xc_azure_az_nodes : k=>v}
  is_multi_nic                            = local.is_multi_nic
  has_public_ip                           = var.has_public_ip
  azurerm_vnet_name                       = module.network_common.common["vnet"]["name"]
  azurerm_resource_group_name             = local.f5xc_azure_resource_group
  azurerm_security_group_slo_id           = module.network_common.common["sg_slo"]["id"]
  azurerm_security_group_sli_id           = local.is_multi_nic ? module.network_common.common["sg_sli"]["id"] : null
  azurerm_security_group_secure_ce_slo_id = var.f5xc_is_secure_cloud_ce ? module.network_common.common["sg_slo_secure_ce"]["id"] : null
  azurerm_security_group_secure_ce_sli_id = local.is_multi_nic && var.f5xc_is_secure_cloud_ce ? module.network_common.common["sg_sli_secure_ce"]["id"] : null
  azurerm_route_table_next_hop_type       = var.azurerm_route_table_next_hop_type
  azurerm_subnet_slo_address_prefix       = [each.value["f5xc_azure_vnet_slo_subnet"]]
  azurerm_subnet_sli_address_prefix       = local.is_multi_nic ? each.value["f5xc_azure_vnet_sli_subnet"] : null
  f5xc_node_name                          = format("%s-%s", var.f5xc_cluster_name, each.key)
  f5xc_azure_region                       = var.f5xc_azure_region
}

module "nlb_common" {
  source                               = "./network/nlb/common"
  count                                = local.is_multi_node ? 1 : 0
  is_multi_nic                         = local.is_multi_nic
  azurerm_resource_group_name          = local.f5xc_azure_resource_group
  azurerm_lb_frontend_ip_configuration = [
    {
      "name"      = "slo"
      "subnet_id" = [for slo_subnet in module.network_node.ce["slo_subnet"] : slo_subnet["id"]]
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
  azurerm_backend_address_pool_id_slo = module.nlb_common[0].common["backend_address_pool_slo"]
  azurerm_backend_address_pool_id_sli = local.is_multi_nic ?  module.nlb_common[0].common["backend_address_pool_sli"] : null
}

module "config" {
  source                      = "./config"
  for_each                    = {for k, v in var.f5xc_azure_az_nodes : k=>v}
  f5xc_azure_region           = var.f5xc_azure_region
  f5xc_cluster_name           = var.f5xc_cluster_name
  f5xc_cluster_labels         = var.f5xc_cluster_labels
  f5xc_ce_gateway_type        = var.f5xc_ce_gateway_type
  f5xc_cluster_latitude       = var.f5xc_cluster_latitude
  f5xc_cluster_longitude      = var.f5xc_cluster_longitude
  f5xc_ce_hosts_public_name   = var.f5xc_ce_hosts_public_name
  azurerm_vnet_name           = var.azurerm_existing_virtual_network_name != "" ? var.azurerm_existing_virtual_network_name : format("%s-vnet", var.f5xc_cluster_name)
  azurerm_tenant_id           = var.azurerm_tenant_id
  azurerm_client_id           = var.azurerm_client_id
  azurerm_client_secret       = var.azurerm_client_secret
  azurerm_resource_group      = local.f5xc_azure_resource_group
  azurerm_subscription_id     = var.azurerm_subscription_id
  azurerm_vnet_subnet_name    = module.network_node[each.key].ce["slo_subnet"]["name"]
  azurerm_vnet_resource_group = local.f5xc_azure_resource_group
  owner_tag                   = var.owner_tag
  ssh_public_key              = var.ssh_public_key

}

module "node" {
  source                                 = "./nodes"
  for_each                               = {for k, v in var.f5xc_azure_az_nodes : k=>v}
  azurerm_marketplace_plan               = azurerm_marketplace_agreement.ce.plan
  azurerm_instance_vm_size               = var.azurerm_instance_vm_size
  azurerm_marketplace_offer              = azurerm_marketplace_agreement.ce.offer
  azurerm_instance_disk_size             = var.azurerm_instance_disk_size
  azurerm_resource_group_name            = local.f5xc_azure_resource_group
  azurerm_availability_set_id            = var.azurerm_availability_set_id
  azurerm_marketplace_version            = var.azurerm_marketplace_version
  azurerm_marketplace_publisher          = azurerm_marketplace_agreement.ce.publisher
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