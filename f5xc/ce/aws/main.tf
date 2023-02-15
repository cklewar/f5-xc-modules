resource "volterra_token" "site" {
  name      = var.f5xc_token_name
  namespace = var.f5xc_namespace
}

resource "aws_key_pair" "aws-key" {
  key_name   = var.f5xc_cluster_name
  public_key = var.ssh_public_key
}

module "network_common" {
  source                              = "./network/common"
  owner_tag                           = var.owner_tag
  common_tags                         = local.common_tags
  f5xc_cluster_name                   = var.f5xc_cluster_name
  f5xc_ce_gateway_type                = var.f5xc_ce_gateway_type
  aws_vpc_cidr_block                  = var.aws_vpc_cidr_block
  aws_security_group_rule_sli_egress  = var.aws_security_group_rule_sli_egress
  aws_security_group_rule_sli_ingress = var.aws_security_group_rule_sli_ingress
  aws_security_group_rule_slo_egress  = var.aws_security_group_rule_slo_egress
  aws_security_group_rule_slo_ingress = var.aws_security_group_rule_slo_ingress
}

module "network_node" {
  source               = "./network/node"
  for_each             = {for k, v in var.f5xc_aws_vpc_az_nodes : k=>v}
  owner_tag            = var.owner_tag
  node_name            = format("%s-%s", var.f5xc_cluster_name, each.key)
  common_tags          = local.common_tags
  has_public_ip        = var.has_public_ip
  f5xc_ce_gateway_type = var.f5xc_ce_gateway_type
  aws_vpc_az           = var.f5xc_aws_vpc_az_nodes[each.key]["f5xc_aws_vpc_az_name"]
  aws_vpc_id           = module.network_common.common["vpc"]["id"]
  aws_sg_slo_id        = module.network_common.common["sg_slo"]["id"]
  aws_sg_sli_id        = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? module.network_common.common["sg_sli"]["id"] : null
  aws_subnet_slo_cidr  = var.f5xc_aws_vpc_az_nodes[each.key]["f5xc_aws_vpc_slo_subnet"]
  aws_subnet_sli_cidr  = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? var.f5xc_aws_vpc_az_nodes[each.key]["f5xc_aws_vpc_sli_subnet"] : null
}

locals {
  is_slo_snet_same_az = length([for node in var.f5xc_aws_vpc_az_nodes : node["f5xc_aws_vpc_az_name"]]) != length(distinct([for node in var.f5xc_aws_vpc_az_nodes : node["f5xc_aws_vpc_az_name"]])) ? true : false
}

module "network_nlb" {
  source            = "./network/nlb"
  count             = length(var.f5xc_aws_vpc_az_nodes) == 3 ? 1 : 0
  common_tags       = local.common_tags
  f5xc_cluster_name = var.f5xc_cluster_name
  aws_vpc_id        = module.network_common.common["vpc"]["id"]
  aws_nlb_subnets   = local.is_slo_snet_same_az ? [var.f5xc_slo_cidr_block] : [for node in module.network_node : node["ce"]["slo_subnet"]["id"]]
}

module "config" {
  source                       = "./config"
  for_each                     = {for k, v in var.f5xc_aws_vpc_az_nodes : k=>v}
  owner_tag                    = var.owner_tag
  ssh_public_key               = var.ssh_public_key
  f5xc_site_token              = volterra_token.site.id
  f5xc_cluster_name            = var.f5xc_cluster_name
  f5xc_server_roles            = local.server_roles[each.key]
  f5xc_cluster_labels          = var.f5xc_cluster_labels
  f5xc_cluster_workload        = var.cluster_workload
  f5xc_cluster_latitude        = var.f5xc_cluster_latitude
  f5xc_cluster_longitude       = var.f5xc_cluster_longitude
  f5xc_ce_gateway_type         = var.f5xc_ce_gateway_type
  f5xc_ce_hosts_public_name    = var.f5xc_ce_hosts_public_name
  f5xc_ce_hosts_public_address = module.network_node[each.key].ce["slo"]["public_dns"][0]
}

module "node" {
  source                      = "./nodes"
  for_each                    = {for k, v in var.f5xc_aws_vpc_az_nodes : k=>v}
  owner_tag                   = var.owner_tag
  common_tags                 = local.common_tags
  is_sensitive                = var.is_sensitive
  f5xc_tenant                 = var.f5xc_tenant
  f5xc_api_url                = var.f5xc_api_url
  f5xc_api_token              = var.f5xc_api_token
  f5xc_namespace              = var.f5xc_namespace
  f5xc_node_name              = format("%s-%s", var.f5xc_cluster_name, each.key)
  f5xc_cluster_name           = var.f5xc_cluster_name
  f5xc_cluster_size           = length(var.f5xc_aws_vpc_az_nodes)
  f5xc_ce_gateway_type        = var.f5xc_ce_gateway_type
  f5xc_instance_config        = module.config[each.key].ce["user_data"]
  f5xc_registration_retry     = var.f5xc_registration_retry
  f5xc_registration_wait_time = var.f5xc_registration_wait_time
  aws_instance_type           = var.instance_type
  aws_instance_image          = var.f5xc_ce_machine_image[var.f5xc_ce_gateway_type][var.f5xc_aws_region]
  aws_subnet_slo_id           = module.network_node[each.key].ce["slo_subnet"]["id"]
  aws_subnet_sli_id           = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? module.network_node[each.key].ce["sli_subnet"]["id"] : null
  aws_interface_slo_id        = module.network_node[each.key].ce["slo"]["id"]
  aws_interface_sli_id        = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? module.network_node[each.key].ce["sli"]["id"] : null
  aws_lb_target_group_arn     = module.network_nlb[0].nlb["target_group"]["id"]
  aws_security_group_slo_id   = module.network_common.common["sg_slo"]["id"]
  aws_security_group_sli_id   = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? module.network_common.common["sg_sli"]["id"] : null
  aws_iam_instance_profile_id = aws_iam_instance_profile.instance_profile.id
  public_ssh_key_name         = aws_key_pair.aws-key.key_name
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