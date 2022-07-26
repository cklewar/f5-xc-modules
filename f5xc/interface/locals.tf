locals {
  content = templatefile(format("%s/templates/%s", path.module, var.interface_template_file), {
    namespace             = var.f5xc_namespace
    tenant                = var.f5xc_tenant
    interface_name        = var.f5xc_interface_name
    tunnel_name           = var.f5xc_tunnel_name
    cluster               = var.f5xc_cluster
    node_name             = var.f5xc_node_name
    interface_static_ip   = var.f5xc_interface_static_ip
    interface_description = var.interface_description
  })
  interface_create_uri = format(var.interface_create_uri, var.namespace)
  interface_delete_uri = format(var.interface_delete_uri, var.namespace)
}