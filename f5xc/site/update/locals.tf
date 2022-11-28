locals {
  content = templatefile(format("%s/templates/%s", path.module, var.f5xc_site_update_template_file), {
    namespace              = var.f5xc_namespace
    tenant                 = var.f5xc_tenant
    global_virtual_network = var.f5xc_global_virtual_network
    cluster_labels         = var.f5xc_cluster_labels
  })

  site_update_uri = format(var.f5xc_site_update_uri, var.f5xc_namespace, var.f5xc_site_name)
}