locals {
  random_id    = uuid()
  # site_get_uri = format(var.f5xc_nfv_get_uri, var.f5xc_namespace, var.f5xc_nfv_name)
  # site_get_url = format("%s/%s?response_format=GET_RSP_FORMAT_DEFAULT", var.f5xc_api_url, local.site_get_uri)
}