locals {
  base_offset               = length(substr(var.f5xc_api_url, 8, -1)) - 4
  is_production_env         = endswith(var.f5xc_api_url, var.production_api_base)
  maurice_endpoint_url      = local.is_production_env ? format("https://%s", replace(substr(substr(substr(var.f5xc_api_url, 8, -1), 0, local.base_offset), 0 - 23, -1), "console", "register")) : format("https://register.%s", substr(substr(substr(var.f5xc_api_url, 8, -1), 0, local.base_offset), 0 - 19, -1))
  maurice_mtls_endpoint_url = local.is_production_env ? format("https://%s", replace(substr(substr(substr(var.f5xc_api_url, 8, -1), 0, local.base_offset), 0 - 23, -1), "console", "register-tls")) : format("https://register-tls.%s", substr(substr(substr(var.f5xc_api_url, 8, -1), 0, local.base_offset), 0 - 19, -1))
}
