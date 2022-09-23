resource "volterra_virtual_k8s" "vk8s" {
  name      = var.f5xc_vk8s_name
  namespace = var.f5xc_namespace

  vsite_refs {
    name      = var.f5xc_virtual_site_refs
    namespace = var.f5xc_namespace
  }

  provisioner "local-exec" {
    command = var.f5xc_vk8s_provisioner_apply_timeout
  }

  provisioner "local-exec" {
    when    = destroy
    command = var.f5xc_vk8s_provisioner_destroy_timeout
  }
}