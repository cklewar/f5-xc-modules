locals {
  is_production_env         = endswith(var.f5xc_api_url, var.production_api_base)
  tenant_id                 = split(".", substr(var.f5xc_api_url, 8, -1))[0]
  base_domain_list          = split(".", split("/", substr(var.f5xc_api_url, 8, -1))[0])
  base_domain               = join(".", slice(local.base_domain_list, 1, length(local.base_domain_list)))
  maurice_endpoint_url      = local.is_production_env ? format("https://register.%s", join(".", slice(local.base_domain_list, 2, length(local.base_domain_list)))) : format("https://register.%s.%s", local.tenant_id, local.base_domain)
  maurice_mtls_endpoint_url = local.is_production_env ? format("https://register-tls.%s", join(".", slice(local.base_domain_list, 2, length(local.base_domain_list)))) : format("https://register-tls.%s.%s", local.tenant_id, local.base_domain)
}