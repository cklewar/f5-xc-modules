resource "volterra_virtual_k8s" "vk8s" {
  name        = var.f5xc_vk8s_name
  namespace   = var.f5xc_namespace
  description = var.f5xc_vk8s_description
  isolated    = var.f5xc_vk8s_isolated
  triggers    = {
    f5xc_vk8s_provisioner_apply_timeout   = var.f5xc_vk8s_provisioner_apply_timeout
    f5xc_vk8s_provisioner_destroy_timeout = var.f5xc_vk8s_provisioner_destroy_timeout
  }

  dynamic "vsite_refs" {
    for_each = length(var.f5xc_virtual_site_refs) > 0 ? var.f5xc_virtual_site_refs : []
    content {
      name      = var.f5xc_virtual_site_refs
      namespace = var.f5xc_namespace
      tenant    = var.f5xc_tenant
    }
  }

  for_each = var.f5xc_vk8s_default_flavor_name != "" ? [1] : []
  content {
    name      = var.f5xc_vk8s_default_flavor_name
    tenant    = var.f5xc_tenant
    namespace = var.f5xc_namespace
  }

  provisioner "local-exec" {
    command = self.triggers.f5xc_vk8s_provisioner_apply_timeout
  }

  provisioner "local-exec" {
    when    = destroy
    command = self.triggers.f5xc_vk8s_provisioner_destroy_timeout
  }
}