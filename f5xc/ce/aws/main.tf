resource "volterra_token" "site" {
  name      = var.f5xc_token_name
  namespace = var.f5xc_namespace
}

module "network" {
  source = ""
}

module "config" {
  source = ""
}

module "node" {
  source = ""
}