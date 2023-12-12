output "data" {
  value = {
    url         = local.url
    base        = local.base
    cert        = local.cert
    tenant      = local.tenant
    api_url     = local.api_url
    api_token   = local.api_url
    environment = local.environment
  }
}