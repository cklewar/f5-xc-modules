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
  cluster_name                        = var.f5xc_cluster_name
  common_tags                         = local.common_tags
  f5xc_ce_gateway_type                = var.f5xc_ce_gateway_type
  aws_vpc_subnet_prefix               = var.aws_vpc_subnet_prefix
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
  cluster_name         = var.f5xc_cluster_name
  has_public_ip        = var.has_public_ip
  f5xc_ce_gateway_type = var.f5xc_ce_gateway_type
  aws_vpc_az           = var.f5xc_aws_vpc_az_nodes[each.key]["f5xc_aws_vpc_az_name"]
  aws_vpc_id           = module.network_common.common["vpc"]["id"]
  aws_sg_slo_id        = module.network_common.common["sg_slo"]["id"]
  aws_sg_sli_id        = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? module.network_common.common["sg_sli"]["id"] : null
  aws_subnet_slo_cidr  = var.f5xc_aws_vpc_az_nodes[each.key]["f5xc_aws_vpc_slo_subnet"]
  aws_subnet_sli_cidr  = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? var.f5xc_aws_vpc_az_nodes[each.key]["f5xc_aws_vpc_sli_subnet"] : null
}

module "network_nlb" {
  source          = "./network/nlb"
  count           = length(var.f5xc_aws_vpc_az_nodes) == 3 ? 1 : 0
  common_tags     = local.common_tags
  cluster_name    = var.f5xc_cluster_name
  aws_vpc_id      = module.network_common.common["vpc"]["id"]
  aws_nlb_subnets = [for subnet in module.network_node.ce["slo_subnet"] : subnet["id"]]
}

module "config" {
  source               = "./config"
  for_each             = {for k, v in var.f5xc_aws_vpc_az_nodes : k=>v}
  owner_tag            = var.owner_tag
  site_token           = volterra_token.site.id
  public_name          = var.public_name
  public_address       = module.network_node[each.key].ce["slo"]["public_dns"][0]
  cluster_name         = var.f5xc_cluster_name
  cluster_labels       = var.f5xc_cluster_labels
  cluster_workload     = var.cluster_workload
  cluster_latitude     = var.f5xc_cluster_latitude
  cluster_longitude    = var.f5xc_cluster_longitude
  f5xc_ce_gateway_type = var.f5xc_ce_gateway_type
  server_roles         = local.server_roles[each.key]
  ssh_public_key       = var.ssh_public_key
}

module "node" {
  source                      = "./nodes"
  for_each                    = {for k, v in var.f5xc_aws_vpc_az_nodes : k=>v}
  owner_tag                   = var.owner_tag
  node_name                   = format("%s-%s", var.f5xc_cluster_name, each.key)
  common_tags                 = local.common_tags
  f5xc_tenant                 = var.f5xc_tenant
  f5xc_api_url                = var.f5xc_api_url
  f5xc_api_token              = var.f5xc_api_token
  f5xc_namespace              = var.f5xc_namespace
  f5xc_ce_gateway_type        = var.f5xc_ce_gateway_type
  f5xc_registration_retry     = var.f5xc_registration_retry
  f5xc_registration_wait_time = var.f5xc_registration_wait_time
  is_sensitive                = var.is_sensitive
  cluster_size                = length(var.f5xc_aws_vpc_az_nodes)
  cluster_name                = var.f5xc_cluster_name
  instance_type               = var.instance_type
  instance_image              = var.f5xc_ce_machine_image[var.f5xc_ce_gateway_type][var.f5xc_aws_region]
  instance_config             = module.config[each.key].ce["user_data"]
  subnet_slo_id               = module.network_node[each.key].ce["slo_subnet"]["id"]
  subnet_sli_id               = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? module.network_node[each.key].ce["sli_subnet"]["id"] : null
  interface_slo_id            = module.network_node[each.key].ce["slo"]["id"]
  interface_sli_id            = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? module.network_node[each.key].ce["sli"]["id"] : null
  lb_target_group_arn         = module.network_nlb.nlb["nlb"]["target_group"]["id"]
  public_ssh_key_name         = aws_key_pair.aws-key.key_name
  security_group_slo_id       = module.network_common.common["sg_slo"]["id"]
  security_group_sli_id       = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? module.network_common.common["sg_sli"]["id"] : null
  iam_instance_profile_id     = module.network_common.common["instance_profile"]["id"]
}