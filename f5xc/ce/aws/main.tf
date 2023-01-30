resource "volterra_token" "site" {
  name      = var.f5xc_token_name
  namespace = var.f5xc_namespace
}

/*module "network" {
  source = ""
}*/

module "config" {
  source               = "./config"
  count                = local.f5xc_aws_vpc_az_nodes
  owner_tag            = var.owner_tag
  public_name          = "vip"
  public_address       = "192.168.2.2" # module.ce_network.balancer_ip
  cluster_name         = var.cluster_name
  cluster_token        = volterra_token.site.id
  cluster_labels       = var.cluster_labels
  cluster_workload     = var.cluster_workload
  cluster_latitude     = "1234.5464"
  cluster_longitude    = "6564.1323"
  ssh_public_key       = "abc123"
  server_roles         = local.server_roles[count.index]
  f5xc_ce_gateway_type = "ingress"
}

/*module "node" {
  source = ""
}*/