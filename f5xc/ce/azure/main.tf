resource "azurerm_marketplace_agreement" "single_node" {
  publisher = "volterraedgeservices"
  offer     = "volterra-node"
  plan      = "volterra-node"
}

module "config" {
  source                    = "./config"
  f5xc_site_token           = ""
  f5xc_cluster_name         = var.f5xc_cluster_name
  f5xc_cluster_labels       = var.f5xc_cluster_labels
  f5xc_ce_gateway_type      = var.f5xc_ce_gateway_type
  f5xc_cluster_workload     = ""
  f5xc_cluster_latitude     = var.f5xc_cluster_latitude
  f5xc_cluster_longitude    = var.f5xc_cluster_longitude
  f5xc_ce_hosts_public_name = ""
  owner_tag                 = ""
  ssh_public_key            = var.ssh_public_key
}

# common
# format("loadbalancer-frontend-%s-ip", frontend_ip_configuration.value.name)

module "network_common" {
  source                                = "./network/common"
  common_tags                           = {}
  is_multi_nic                          = local.is_multi_nic
  is_multi_node                         = local.is_multi_node
  vip_params_per_az                     = []
  azurerm_vnet_address_space            = []
  azurerm_resource_group_name           = ""
  azure_linux_security_sli_rules        = []
  azure_linux_security_slo_rules        = []
  azurerm_frontend_ip_configuration     = []
  azurerm_network_interface_sli_id      = ""
  azurerm_network_interface_slo_id      = ""
  azurerm_existing_virtual_network_name = ""
  f5xc_azure_region                     = var.f5xc_azure_region
  f5xc_cluster_name                     = var.f5xc_cluster_name
  f5xc_site_set_vip_info_namespace      = ""
}

module "network_node" {
  source                            = "./network/node"
  for_each                          = {for k, v in var.f5xc_azure_az_nodes : k=>v}
  azurerm_vnet_name                 = ""
  azurerm_resource_group_name       = var.f5xc_existing_azure_resource_group != "" ? var.f5xc_existing_azure_resource_group : format("%s-rg", var.f5xc_cluster_name)
  azurerm_security_group_sli_id     = ""
  azurerm_security_group_slo_id     = ""
  azurerm_backend_address_pool_id   = ""
  azurerm_route_table_next_hop_type = ""
  f5xc_node_name                    = format("%s-%s", var.f5xc_cluster_name, each.key)
  f5xc_azure_region                 = var.f5xc_azure_region
  f5xc_ce_public_ip_id              = ""
  has_public_ip                     = var.has_public_ip
  is_multi_nic                      = local.is_multi_nic
  subnet_sli_id                     = ""
  subnet_slo_id                     = ""
}

module "node" {
  source                                 = "./nodes"
  for_each                               = {for k, v in var.f5xc_azure_az_nodes : k=>v}
  azurerm_marketplace_sku                = azurerm_marketplace_agreement.single_node.plan
  azurerm_instance_vm_size               = var.azurerm_instance_vm_size
  azurerm_marketplace_name               = ""
  azurerm_marketplace_offer              = azurerm_marketplace_agreement.single_node.offer
  azurerm_instance_disk_size             = var.azurerm_instance_disk_size
  azurerm_resource_group_name            = var.f5xc_existing_azure_resource_group != "" ? var.f5xc_existing_azure_resource_group : format("%s-rg", var.f5xc_cluster_name)
  azurerm_availability_set_id            = ""
  azurerm_marketplace_version            = ""
  azurerm_marketplace_publisher          = azurerm_marketplace_agreement.single_node.publisher
  azurerm_instance_admin_username        = var.azurerm_instance_admin_username
  azurerm_primary_network_interface_id   = ""
  azurerm_instance_network_interface_ids = []
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
# depends_on                       = [azurerm_marketplace_agreement.volterra]
# azurerm_public_ip.compute_public_ip.*.id
# }

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