resource "volterra_virtual_k8s" "vk8s" {
  name        = var.f5xc_vk8s_name
  namespace   = var.f5xc_namespace
  description = var.f5xc_vk8s_description
  isolated    = var.f5xc_vk8s_isolated
  labels      = local.f5xc_labels

  dynamic "vsite_refs" {
    for_each = length(var.f5xc_virtual_site_refs) > 0 ? var.f5xc_virtual_site_refs : []
    content {
      name      = var.f5xc_virtual_site_refs
      namespace = var.f5xc_namespace
      tenant    = var.f5xc_tenant
    }
  }

  /*dynamic "default_flavor_ref" {
    for_each = var.f5xc_vk8s_default_flavor_name != "" ? [1] : []
    content {
      name      = var.f5xc_vk8s_default_flavor_name
      tenant    = var.f5xc_tenant
      namespace = var.f5xc_namespace
    }
  }*/
}