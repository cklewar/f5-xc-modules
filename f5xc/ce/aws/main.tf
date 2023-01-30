resource "volterra_token" "site" {
  name      = var.f5xc_token_name
  namespace = var.f5xc_namespace
}

module "network" {
  source = ""
}

module "config" {
  source                              = "./config"
  ves_env                             = var.ves_env
  public_name                         = "vip"
  public_address                      = "192.168.2.2" # module.ce_network.balancer_ip
  private_vn_prefix                   = var.private_vn_prefix
  private_default_gw                  = var.private_default_gw
  cluster_name                        = var.cluster_name
  cluster_token                       = volterra_token.site.id
  cluster_labels                      = var.cluster_labels
  cluster_workload                    = var.cluster_workload
  cluster_latitude                    = ""
  cluster_longitude                   = ""
  master_count                        = local.master_count
  ssh_public_key                      = ""
  customer_route                      = var.customer_route
  f5xc_ce_gateway_type                = "ingress"
}

module "node" {
  source = ""
}