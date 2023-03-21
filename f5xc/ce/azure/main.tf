resource "azurerm_marketplace_agreement" "volterra" {
  count     = length(local.marketplace) > 0 ? 1 : 0
  publisher = lookup(local.marketplace, "publisher", "volterraedgeservices")
  offer     = lookup(local.marketplace, "offer", "volterra-node")
  plan      = lookup(local.marketplace, "sku", "volterra-node")
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