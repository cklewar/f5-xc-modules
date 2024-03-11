output "data" {
  value = {
    url         = local.url
    base        = local.base
    tenant      = local.tenant
    api_url     = local.api_url
    p12_file    = local.p12_file
    api_token   = local.api_token
    environment = local.environment
  }
}