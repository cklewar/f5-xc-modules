resource "azurerm_marketplace_agreement" "single_node" {
  publisher = "volterraedgeservices"
  offer     = "volterra-node"
  plan      = "volterra-node"
}

# common
# format("loadbalancer-frontend-%s-ip", frontend_ip_configuration.value.name)

# modules "node" {
# depends_on                       = [azurerm_marketplace_agreement.volterra]
# azurerm_public_ip.compute_public_ip.*.id
# }

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