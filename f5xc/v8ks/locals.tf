locals {
  f5xc_api_token = var.is_sensitive ? sensitive(var.f5xc_api_token) : var.f5xc_api_token
  f5xc_tenant    = var.is_sensitive ? sensitive(var.f5xc_tenant) : var.f5xc_tenant
  f5xc_labels    = merge({
    tf_vk8s_filter = var.f5xc_vk8s_name
  }, var.f5xc_labels)
}