module "site_wait_for_online" {
  depends_on     = [volterra_registration_approval.ce]
  source         = "../../../../../../f5xc/status/site"
  f5xc_namespace = var.f5xc_namespace
  f5xc_api_token = var.f5xc_api_token
  f5xc_api_url   = var.f5xc_api_url
  f5xc_site_name = var.site_name
  f5xc_tenant    = var.f5xc_tenant
}