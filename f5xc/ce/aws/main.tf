resource "volterra_token" "site" {
  name      = var.f5xc_token_name
  namespace = var.f5xc_namespace
}

module "network" {
  source                = "./network"
  owner_tag             = var.owner_tag
  cluster_name          = var.cluster_name
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
  public_address       = module.network.ce["nlb"]["dns_name"]
  cluster_name         = var.cluster_name
  cluster_token        = volterra_token.site.id
  cluster_labels       = var.cluster_labels
  cluster_workload     = var.cluster_workload
  cluster_latitude     = var.cluster_latitude
  cluster_longitude    = var.cluster_longitude
  ssh_public_key       = var.ssh_public_key
  server_roles         = local.server_roles[each.key]
  f5xc_ce_gateway_type = var.f5xc_ce_gateway_type
}

module "node" {
  source                      = "./nodes"
  f5xc_api_url                = var.f5xc_api_url
  f5xc_api_token              = var.f5xc_api_token
  f5xc_namespace              = var.f5xc_namespace
  f5xc_registration_retry     = 5
  f5xc_registration_wait_time = 60
  f5xc_tenant                 = var.f5xc_tenant
  instance_name               = ""
  machine_config              = ""
  machine_image               = ""
  machine_public_key          = var.ssh_public_key
  owner_tag                   = var.owner_tag
  region                      = var.f5xc_aws_region
  security_group_private_id   = ""
  subnet_inside_id            = ""
  subnet_private_id           = ""
}