resource "volterra_token" "site" {
  name      = var.f5xc_token_name != "" ? var.f5xc_token_name : var.f5xc_cluster_name
  namespace = var.f5xc_namespace
}

resource "aws_key_pair" "aws_key" {
  key_name   = var.f5xc_cluster_name
  public_key = var.ssh_public_key
}

module "maurice" {
  source       = "../../../../utils/maurice"
  f5xc_api_url = var.f5xc_api_url
}

module "network_common" {
  source                               = "./network/common"
  owner_tag                            = var.owner_tag
  common_tags                          = local.common_tags
  create_new_aws_vpc                   = var.create_new_aws_vpc
  f5xc_cluster_name                    = var.f5xc_cluster_name
  aws_vpc_cidr_block                   = var.aws_vpc_cidr_block
  aws_existing_vpc_id                  = var.aws_existing_vpc_id
  aws_security_group_rules_slo_egress  = length(var.aws_security_group_rules_slo_egress) > 0 ? var.aws_security_group_rules_slo_egress : var.aws_security_group_rules_slo_egress_default
  aws_security_group_rules_slo_ingress = length(var.aws_security_group_rules_slo_ingress) > 0 ? var.aws_security_group_rules_slo_ingress : var.aws_security_group_rules_slo_ingress_default
}

module "network_master_node" {
  source                     = "./network/node"
  for_each                   = {for k, v in var.f5xc_cluster_nodes.master : k=>v}
  owner_tag                  = var.owner_tag
  node_name                  = format("%s-%s", var.f5xc_cluster_name, each.key)
  common_tags                = local.common_tags
  has_public_ip              = var.has_public_ip
  aws_vpc_az                 = var.f5xc_cluster_nodes.master[each.key]["f5xc_aws_vpc_az_name"]
  aws_vpc_id                 = var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : module.network_common.common["vpc"]["id"]
  aws_sg_slo_ids             = module.network_common.common["sg_slo_ids"]
  aws_subnet_slo_cidr        = var.f5xc_cluster_nodes.master[each.key]["aws_vpc_slo_subnet"]
  aws_slo_subnet_rt_id       = module.network_common.common["slo_subnet_rt"]["id"]
  aws_existing_slo_subnet_id = contains(keys(var.f5xc_cluster_nodes.master[each.key]), "aws_existing_slo_subnet_id") ? var.f5xc_cluster_nodes.master[each.key]["aws_existing_slo_subnet_id"] : null
}

module "network_worker_node" {
  source                     = "./network/node"
  for_each                   = {for k, v in var.f5xc_cluster_nodes.worker : k=>v}
  owner_tag                  = var.owner_tag
  node_name                  = format("%s-%s", var.f5xc_cluster_name, each.key)
  common_tags                = local.common_tags
  has_public_ip              = var.has_public_ip
  aws_vpc_az                 = var.f5xc_cluster_nodes.worker[each.key]["f5xc_aws_vpc_az_name"]
  aws_vpc_id                 = var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : module.network_common.common["vpc"]["id"]
  aws_sg_slo_ids             = module.network_common.common["sg_slo_ids"]
  aws_subnet_slo_cidr        = var.f5xc_cluster_nodes.worker[each.key]["aws_vpc_slo_subnet"]
  aws_slo_subnet_rt_id       = module.network_common.common["slo_subnet_rt"]["id"]
  aws_existing_slo_subnet_id = contains(keys(var.f5xc_cluster_nodes.worker[each.key]), "aws_existing_slo_subnet_id") ? var.f5xc_cluster_nodes.worker[each.key]["aws_existing_slo_subnet_id"] : null
}

module "network_nlb" {
  source            = "./network/nlb"
  count             = length(var.f5xc_cluster_nodes.master) == 3 ? 1 : 0
  common_tags       = local.common_tags
  f5xc_cluster_name = var.f5xc_cluster_name
  aws_vpc_id        = var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : module.network_common.common["vpc"]["id"]
  aws_nlb_subnets   = [for node in module.network_master_node : node["ce"]["slo_subnet"]["id"]]
}

module "config_master_node" {
  source                    = "./config"
  for_each                  = {for k, v in var.f5xc_cluster_nodes.master : k=>v}
  node_type                 = "master"
  ssh_public_key            = var.ssh_public_key
  f5xc_site_token           = volterra_token.site.id
  f5xc_cluster_name         = var.f5xc_cluster_name
  f5xc_cluster_labels       = {} # var.f5xc_cluster_labels
  f5xc_cluster_latitude     = var.f5xc_cluster_latitude
  f5xc_cluster_longitude    = var.f5xc_cluster_longitude
  f5xc_ce_hosts_public_name = var.f5xc_ce_hosts_public_name
  maurice_endpoint          = module.maurice.endpoints.maurice
  maurice_mtls_endpoint     = module.maurice.endpoints.maurice_mtls
}

module "config_worker_node" {
  source                    = "./config"
  for_each                  = {for k, v in var.f5xc_cluster_nodes.worker : k=>v}
  node_type                 = "worker"
  ssh_public_key            = var.ssh_public_key
  f5xc_site_token           = volterra_token.site.id
  f5xc_cluster_name         = var.f5xc_cluster_name
  f5xc_cluster_labels       = {} # var.f5xc_cluster_labels
  f5xc_cluster_latitude     = var.f5xc_cluster_latitude
  f5xc_cluster_longitude    = var.f5xc_cluster_longitude
  f5xc_ce_hosts_public_name = var.f5xc_ce_hosts_public_name
  aws_nlb_dns_name          = length(var.f5xc_cluster_nodes.master) == 3 ? module.network_nlb[0].nlb["nlb"]["dns_name"] : ""
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
  depends_on                  = [module.cluster]
  source                      = "./nodes/master"
  for_each                    = {for k, v in var.f5xc_cluster_nodes.master : k=>v}
  owner_tag                   = var.owner_tag
  common_tags                 = local.common_tags
  f5xc_node_name              = format("%s-%s", var.f5xc_cluster_name, each.key)
  f5xc_cluster_name           = var.f5xc_cluster_name
  f5xc_cluster_size           = length(var.f5xc_cluster_nodes.master)
  f5xc_instance_config        = module.config_master_node[each.key].ce["user_data"]
  f5xc_cluster_latitude       = var.f5xc_cluster_latitude
  f5xc_cluster_longitude      = var.f5xc_cluster_longitude
  f5xc_registration_retry     = var.f5xc_registration_retry
  f5xc_registration_wait_time = var.f5xc_registration_wait_time
  f5xc_ce_to_re_tunnel_type   = var.f5xc_ce_to_re_tunnel_type
  aws_instance_type           = var.aws_instance_type_master
  aws_instance_image          = var.f5xc_ce_machine_image[var.f5xc_ce_gateway_type][var.aws_region]
  aws_interface_slo_id        = module.network_master_node[each.key].ce["slo"]["id"]
  aws_lb_target_group_arn     = length(var.f5xc_cluster_nodes.master) == 3 ? module.network_nlb[0].nlb["target_group"]["arn"] : null
  aws_iam_instance_profile_id = aws_iam_instance_profile.instance_profile.id
  ssh_public_key_name         = aws_key_pair.aws_key.key_name
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
  depends_on                  = [module.site_wait_for_online_master]
  source                      = "./nodes/worker"
  for_each                    = {for k, v in var.f5xc_cluster_nodes.worker : k=>v}
  owner_tag                   = var.owner_tag
  common_tags                 = local.common_tags
  aws_instance_type           = var.aws_instance_type_worker
  aws_instance_image          = var.f5xc_ce_machine_image[var.f5xc_ce_gateway_type][var.aws_region]
  aws_interface_slo_id        = module.network_worker_node[each.key].ce["slo"]["id"]
  aws_iam_instance_profile_id = aws_iam_instance_profile.instance_profile.id
  ssh_public_key_name         = aws_key_pair.aws_key.key_name
  f5xc_node_name              = format("%s-worker-%s", var.f5xc_cluster_name, each.key)
  f5xc_cluster_name           = var.f5xc_cluster_name
  f5xc_cluster_size           = length(var.f5xc_cluster_nodes.worker)
  f5xc_instance_config        = module.config_worker_node[each.key].ce["user_data"]
  f5xc_cluster_latitude       = var.f5xc_cluster_latitude
  f5xc_cluster_longitude      = var.f5xc_cluster_longitude
  f5xc_registration_retry     = var.f5xc_registration_retry
  f5xc_ce_to_re_tunnel_type   = var.f5xc_ce_to_re_tunnel_type
  f5xc_registration_wait_time = var.f5xc_registration_wait_time
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