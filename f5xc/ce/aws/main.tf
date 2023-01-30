resource "volterra_token" "site" {
  name      = var.f5xc_token_name
  namespace = var.f5xc_namespace
}

/*module "network" {
  source = ""
}*/

module "config" {
  source               = "./config"
  for_each             = {for k,v in local.f5xc_aws_vpc_az_nodes : k=>v}
  owner_tag            = var.owner_tag
  public_name          = var.public_name
  public_address       = "192.168.2.2" # module.ce_network.balancer_ip
  cluster_name         = var.cluster_name
  cluster_token        = volterra_token.site.id
  cluster_labels       = var.cluster_labels
  cluster_workload     = var.cluster_workload
  cluster_latitude     = var.cluster_latitude
  cluster_longitude    = var.cluster_longitude
  ssh_public_key       = var.ssh_public_key
  server_roles         = local.server_roles["node0"]
  f5xc_ce_gateway_type = var.f5xc_ce_gateway_type
}

/*module "node" {
  source = ""
}*/