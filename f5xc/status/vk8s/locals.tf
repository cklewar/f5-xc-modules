locals {
  random_id           = uuid()
  site_get_uri        = format(var.f5xc_vk8s_get_uri, var.f5xc_namespace, var.f5xc_vk8s_name)
  site_get_url        = format("%s/%s", var.f5xc_api_url, local.site_get_uri)
  site_get_uri_filter = format(var.f5xc_vk8s_get_uri_filter, var.f5xc_namespace, var.f5xc_vk8s_name)
  site_get_url_filter = format("%s/%s", var.f5xc_api_url, local.site_get_uri_filter)
}