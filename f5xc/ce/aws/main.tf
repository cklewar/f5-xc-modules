resource "volterra_token" "site" {
  name      = var.f5xc_token_name
  namespace = var.f5xc_namespace
}

module "network" {
  source                = "./network"
  owner_tag             = var.owner_tag
  cluster_name          = var.f5xc_cluster_name
  aws_region            = var.f5xc_aws_region
  aws_vpc_subnet_prefix = var.aws_vpc_subnet_prefix
  f5xc_ce_gateway_type  = var.f5xc_ce_gateway_type
  f5xc_aws_vpc_az_nodes = var.f5xc_aws_vpc_az_nodes
}

module "config" {
  source               = "./config"
  for_each             = {for k, v in var.f5xc_aws_vpc_az_nodes : k=>v}
  owner_tag            = var.owner_tag
  public_name          = var.public_name
  public_address       = module.network.common["nlb"]["dns_name"]
  cluster_name         = var.f5xc_cluster_name
  cluster_token        = volterra_token.site.id
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
  f5xc_tenant                 = var.f5xc_tenant
  f5xc_api_url                = var.f5xc_api_url
  f5xc_api_token              = var.f5xc_api_token
  f5xc_namespace              = var.f5xc_namespace
  f5xc_ce_gateway_type        = var.f5xc_ce_gateway_type
  f5xc_registration_retry     = var.f5xc_registration_retry
  f5xc_registration_wait_time = var.f5xc_registration_wait_time
  is_sensitive                = false
  cluster_name                = var.f5xc_cluster_name
  cluster_size                = length(var.f5xc_aws_vpc_az_nodes)
  instance_name               = format("%s-%s", var.f5xc_cluster_name, index(var.f5xc_aws_vpc_az_nodes, each.value) + 1)
  machine_image               = var.machine_image
  machine_config              = module.config[each.key].ce
  machine_public_key          = var.ssh_public_key
  subnet_slo_id               = module.network.nodes[each.key]["slo_subnet"]["id"]
  subnet_sli_id               = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? module.network.nodes[each.key]["sli_subnet"]["id"] : ""
  security_group_private_id   = module.network.common["sg"]["id"]
}