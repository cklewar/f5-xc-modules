locals {
  _tmp        = split(".", local.url)
  url         = var.f5xc_url
  base        = join(".", slice(local._tmp, 1, length(local._tmp)))
  cert        = contains(local._tmp, var.contains_string) ? "${local.url}${local.file_suffix}" : "${local.tenant}.staging${local.file_suffix}"
  tenant      = split(".", local.url)[0]
  tenant_full = ""
  schema      = var.schema
  api_url     = "${local.schema}${local.url}/api"
  api_token   = "${local.environment}_api_token"
  file_suffix = var.file_suffix
  environment = contains(local._tmp, "console") ? "production" : "staging"
}