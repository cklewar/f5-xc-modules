output "endpoints" {
  value = {
    maurice      = local.maurice_endpoint_url
    maurice_mtls = local.maurice_mtls_endpoint_url
  }
}