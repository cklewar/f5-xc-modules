resource "volterra_token" "site" {
  name      = var.f5xc_token_name
  namespace = var.f5xc_namespace
}

resource "aws_key_pair" "aws_key" {
  count      = var.ssh_public_key != null ? 1 : 0
  key_name   = var.f5xc_cluster_name
  public_key = var.ssh_public_key
}

module "maurice" {
  source       = "../../../utils/maurice"
  f5xc_api_url = var.f5xc_api_url
}

module "network_common" {
  source                                                 = "./network/common"
  owner_tag                                              = var.owner_tag
  common_tags                                            = local.common_tags
  is_multi_nic                                           = local.is_multi_nic
  create_new_aws_vpc                                     = var.create_new_aws_vpc
  create_new_aws_igw                                     = var.create_new_aws_igw
  create_new_aws_slo_rt                                  = var.create_new_aws_slo_rt
  create_new_aws_sli_rt                                  = var.create_new_aws_sli_rt
  f5xc_cluster_name                                      = var.f5xc_cluster_name
  f5xc_is_secure_cloud_ce                                = var.f5xc_is_secure_cloud_ce
  f5xc_ce_slo_enable_secure_sg                           = var.f5xc_ce_slo_enable_secure_sg
  aws_vpc_cidr_block                                     = var.aws_vpc_cidr_block
  aws_existing_vpc_id                                    = var.aws_existing_vpc_id
  aws_slo_rt_custom_ipv4_routes                          = var.aws_slo_rt_custom_ipv4_routes
  aws_slo_rt_custom_ipv6_routes                          = var.aws_slo_rt_custom_ipv6_routes
  aws_security_group_rules_sli_egress                    = local.is_multi_nic ? var.create_new_sli_security_group ? (length(var.aws_security_group_rules_sli_egress) > 0 ? var.aws_security_group_rules_sli_egress : var.aws_security_group_rules_sli_egress_default) : [] : []
  aws_security_group_rules_sli_ingress                   = local.is_multi_nic ? var.create_new_sli_security_group ? (length(var.aws_security_group_rules_sli_ingress) > 0 ? var.aws_security_group_rules_sli_ingress : var.aws_security_group_rules_sli_ingress_default) : [] : []
  aws_security_group_rules_slo_egress                    = var.create_new_slo_security_group ? length(var.aws_security_group_rules_slo_egress) > 0 ? var.aws_security_group_rules_slo_egress : (local.is_secure_or_private_cloud_ce == false && var.f5xc_ce_slo_enable_secure_sg == false ? var.aws_security_group_rules_slo_egress_default : null) : null
  aws_security_group_rules_slo_ingress                   = var.create_new_slo_security_group ? length(var.aws_security_group_rules_slo_ingress) > 0 ? var.aws_security_group_rules_slo_ingress : (local.is_secure_or_private_cloud_ce == false && var.f5xc_ce_slo_enable_secure_sg == false ? var.aws_security_group_rules_slo_ingress_default : null) : null
  aws_security_group_rules_sli_egress_secure_ce          = var.f5xc_is_secure_cloud_ce ? local.aws_security_group_rules_sli_egress_secure_ce : []
  aws_security_group_rules_sli_ingress_secure_ce         = var.f5xc_is_secure_cloud_ce ? local.aws_security_group_rules_sli_ingress_secure_ce : []
  aws_security_group_rules_slo_egress_secure_ce          = var.f5xc_is_secure_cloud_ce || var.f5xc_ce_slo_enable_secure_sg ? local.aws_security_group_rules_slo_egress_secure_ce : []
  aws_security_group_rules_slo_egress_secure_ce_extended = var.f5xc_is_secure_cloud_ce || var.f5xc_ce_slo_enable_secure_sg ? local.aws_security_group_rules_slo_egress_secure_ce_extended : []
  aws_security_group_rules_slo_ingress_secure_ce         = var.f5xc_is_secure_cloud_ce || var.f5xc_ce_slo_enable_secure_sg ? local.aws_security_group_rules_slo_ingress_secure_ce : []
}

module "network_node" {
  source                             = "./network/node"
  for_each                           = {for k, v in var.f5xc_aws_vpc_az_nodes : k => v}
  owner_tag                          = var.owner_tag
  node_name                          = format("%s-%s", var.f5xc_cluster_name, each.key)
  common_tags                        = local.common_tags
  is_multi_nic                       = local.is_multi_nic
  has_public_ip                      = var.has_public_ip
  create_new_aws_sli_rta             = var.create_new_aws_sli_rta
  create_new_aws_slo_rta             = var.create_new_aws_slo_rta
  aws_vpc_az                         = var.f5xc_aws_vpc_az_nodes[each.key]["aws_vpc_az_name"]
  aws_vpc_id                         = var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : module.network_common.common["vpc"]["id"]
  aws_sg_sli_ids                     = local.is_multi_nic ? length(var.aws_existing_sg_sli_ids) > 0 ? var.aws_existing_sg_sli_ids : module.network_common.common["sg_sli_ids"] : []
  aws_sg_slo_ids                     = length(var.aws_existing_sg_slo_ids) > 0 ? var.aws_existing_sg_slo_ids : module.network_common.common["sg_slo_ids"]
  aws_slo_static_ips                 = contains(keys(var.f5xc_aws_vpc_az_nodes[each.key]), "aws_slo_static_ips") ? var.f5xc_aws_vpc_az_nodes[each.key]["aws_slo_static_ips"] : []
  aws_subnet_slo_cidr                = contains(keys(var.f5xc_aws_vpc_az_nodes[each.key]), "aws_vpc_slo_subnet") ? var.f5xc_aws_vpc_az_nodes[each.key]["aws_vpc_slo_subnet"] : null
  aws_subnet_sli_cidr                = local.is_multi_nic && contains(keys(var.f5xc_aws_vpc_az_nodes[each.key]), "aws_vpc_sli_subnet") ? var.f5xc_aws_vpc_az_nodes[each.key]["aws_vpc_sli_subnet"] : null
  aws_slo_subnet_rt_id               = var.create_new_aws_slo_rt ? module.network_common.common["slo_subnet_rt"]["id"] : null
  aws_sli_subnet_rt_id               = local.is_multi_nic && var.create_new_aws_sli_rt ? module.network_common.common["sli_subnet_rt"]["id"] : null
  aws_existing_sli_subnet_id         = local.is_multi_nic && contains(keys(var.f5xc_aws_vpc_az_nodes[each.key]), "aws_existing_sli_subnet_id") ? var.f5xc_aws_vpc_az_nodes[each.key]["aws_existing_sli_subnet_id"] : null
  aws_existing_slo_subnet_id         = contains(keys(var.f5xc_aws_vpc_az_nodes[each.key]), "aws_existing_slo_subnet_id") ? var.f5xc_aws_vpc_az_nodes[each.key]["aws_existing_slo_subnet_id"] : null
  f5xc_is_secure_or_private_cloud_ce = local.is_secure_or_private_cloud_ce
}

module "secure_ce" {
  source                = "./network/secure"
  common_tags           = local.common_tags
  for_each              = var.has_public_ip == false && var.f5xc_is_secure_cloud_ce ? {for k, v in var.f5xc_aws_vpc_az_nodes : k => v} : {}
  aws_vpc_id            = var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : module.network_common.common["vpc"]["id"]
  aws_vpc_az            = var.f5xc_aws_vpc_az_nodes[each.key]["aws_vpc_az_name"]
  aws_vpc_nat_gw_subnet = var.f5xc_aws_vpc_az_nodes[each.key]["aws_vpc_nat_gw_subnet"]
  slo_subnet_id         = module.network_node[each.key].ce["slo_subnet"]["id"]
  slo_subnet_rt_id      = module.network_common.common["slo_subnet_rt"]["id"]
  f5xc_node_name        = format("%s-%s", var.f5xc_cluster_name, each.key)
}

module "private_ce" {
  source                = "./network/private"
  common_tags           = local.common_tags
  for_each              = var.has_public_ip == false && var.f5xc_is_private_cloud_ce ? {for k, v in var.f5xc_aws_vpc_az_nodes : k => v} : {}
  aws_vpc_id            = var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : module.network_common.common["vpc"]["id"]
  aws_vpc_az            = var.f5xc_aws_vpc_az_nodes[each.key]["aws_vpc_az_name"]
  aws_vpc_nat_gw_subnet = var.f5xc_aws_vpc_az_nodes[each.key]["aws_vpc_nat_gw_subnet"]
  slo_subnet_id         = module.network_node[each.key].ce["slo_subnet"]["id"]
  slo_subnet_rt_id      = module.network_common.common["slo_subnet_rt"]["id"]
  f5xc_node_name        = format("%s-%s", var.f5xc_cluster_name, each.key)
}

module "network_nlb" {
  source            = "./network/nlb"
  count             = length(var.f5xc_aws_vpc_az_nodes) == 3 ? 1 : 0
  common_tags       = local.common_tags
  f5xc_cluster_name = var.f5xc_cluster_name
  aws_vpc_id        = var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : module.network_common.common["vpc"]["id"]
  aws_nlb_subnets   = [for node in module.network_node : node["ce"]["slo_subnet"]["id"]]
}

module "config" {
  source                       = "./config"
  for_each                     = {for k, v in var.f5xc_aws_vpc_az_nodes : k => v}
  owner_tag                    = var.owner_tag
  ssh_public_key               = var.ssh_public_key != null ? aws_key_pair.aws_key.0.public_key : data.aws_key_pair.existing_aws_key.0.public_key
  f5xc_site_token              = volterra_token.site.id
  f5xc_cluster_name            = var.f5xc_cluster_name
  f5xc_server_roles            = local.server_roles[each.key]
  f5xc_cluster_labels = {} # var.f5xc_cluster_labels
  f5xc_cluster_workload        = var.cluster_workload
  f5xc_cluster_latitude        = var.f5xc_cluster_latitude
  f5xc_cluster_longitude       = var.f5xc_cluster_longitude
  f5xc_ce_gateway_type         = var.f5xc_ce_gateway_type
  f5xc_ce_hosts_public_name    = var.f5xc_ce_hosts_public_name
  f5xc_ce_hosts_public_address = !var.has_public_ip && var.f5xc_is_secure_cloud_ce ? module.secure_ce[each.key].ce["eip"][0]["public_dns"] : !var.has_public_ip && var.f5xc_is_private_cloud_ce ? module.private_ce[each.key].ce["eip"][0]["public_dns"] : !var.has_public_ip ? module.network_node[each.key].ce["slo"]["private_dns_name"] : module.network_node[each.key].ce["slo"]["public_dns"][0]
  maurice_endpoint             = module.maurice.endpoints.maurice
  maurice_mtls_endpoint        = module.maurice.endpoints.maurice_mtls
}

module "secure_mesh_site" {
  count                                  = var.f5xc_site_type_is_secure_mesh_site ? 1 : 0
  source                                 = "../../secure_mesh_site"
  csp_provider                           = "aws"
  f5xc_nodes                             = [for k in keys(var.f5xc_aws_vpc_az_nodes) : { name = k }]
  f5xc_tenant                            = var.f5xc_tenant
  f5xc_api_url                           = var.f5xc_api_url
  f5xc_namespace                         = var.f5xc_namespace
  f5xc_api_token                         = var.f5xc_api_token
  f5xc_cluster_name                      = var.f5xc_cluster_name
  f5xc_cluster_labels                    = {} # var.f5xc_cluster_labels
  f5xc_ce_gateway_type                   = var.f5xc_ce_gateway_type
  f5xc_cluster_latitude                  = var.f5xc_cluster_latitude
  f5xc_cluster_longitude                 = var.f5xc_cluster_longitude
  f5xc_ce_performance_enhancement_mode   = var.f5xc_ce_performance_enhancement_mode
  f5xc_enable_offline_survivability_mode = var.f5xc_enable_offline_survivability_mode
  f5xc_cluster_default_blocked_services  = var.f5xc_cluster_default_blocked_services
}

module "node" {
  depends_on                    = [module.secure_mesh_site]
  source                        = "./nodes"
  for_each                      = {for k, v in var.f5xc_aws_vpc_az_nodes : k => v}
  owner_tag                     = var.owner_tag
  common_tags                   = local.common_tags
  is_multi_nic                  = local.is_multi_nic
  f5xc_node_name                = format("%s-%s", var.f5xc_cluster_name, each.key)
  f5xc_cluster_name             = var.f5xc_cluster_name
  f5xc_cluster_size             = length(var.f5xc_aws_vpc_az_nodes)
  f5xc_instance_config          = module.config[each.key].ce["user_data"]
  f5xc_cluster_latitude         = var.f5xc_cluster_latitude
  f5xc_cluster_longitude        = var.f5xc_cluster_longitude
  f5xc_registration_retry       = var.f5xc_registration_retry
  f5xc_ce_to_re_tunnel_type     = var.f5xc_ce_to_re_tunnel_type
  f5xc_registration_wait_time   = var.f5xc_registration_wait_time
  aws_instance_type             = var.aws_instance_type
  aws_instance_image            = var.f5xc_ce_machine_image[var.f5xc_ce_gateway_type][var.aws_region]
  aws_interface_slo_id          = module.network_node[each.key].ce["slo"]["id"]
  aws_interface_sli_id          = local.is_multi_nic ? module.network_node[each.key].ce["sli"]["id"] : null
  aws_lb_target_group_arn       = length(var.f5xc_aws_vpc_az_nodes) == 3 ? module.network_nlb[0].nlb["target_group"]["arn"] : null
  aws_iam_instance_profile_name = var.aws_existing_iam_profile_name != null ? data.aws_iam_instance_profile.existing_iam_profile.0.name : aws_iam_instance_profile.instance_profile.0.name
  ssh_public_key_name           = var.ssh_public_key != null ? aws_key_pair.aws_key.0.key_name : data.aws_key_pair.existing_aws_key.0.key_name
}

module "site_wait_for_online" {
  depends_on                 = [module.node]
  source                     = "../../status/site"
  is_sensitive               = var.is_sensitive
  f5xc_api_token             = var.f5xc_api_token
  f5xc_tenant                = var.f5xc_tenant
  f5xc_api_url               = var.f5xc_api_url
  f5xc_site_name             = var.f5xc_cluster_name
  f5xc_namespace             = var.f5xc_namespace
  f5xc_api_p12_file          = var.f5xc_api_p12_file
  status_check_type          = var.status_check_type
  f5xc_api_p12_cert_password = var.f5xc_api_p12_cert_password
}