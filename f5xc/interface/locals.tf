locals {
  tunnel_interface_content = templatefile(format("%s/templates/%s", path.module, var.f5xc_tunnel_interface_template_file), {
    namespace                 = var.f5xc_namespace
    tenant                    = var.f5xc_tenant
    interface_name            = var.f5xc_interface_name
    tunnel_name               = var.f5xc_tunnel_name
    cluster                   = var.f5xc_apply_to_cluster
    node                      = var.f5xc_apply_to_node
    node_name                 = var.f5xc_node_name
    interface_static_ip       = var.f5xc_interface_static_ip
    interface_description     = var.f5xc_interface_description
    mtu                       = var.f5xc_interface_mtu
    site_local_network        = var.f5xc_interface_site_local_network
    site_local_inside_network = var.f5xc_interface_site_local_inside_network
    inside_network            = var.f5xc_interface_inside_network
    interface_dns_server      = var.f5xc_interface_dns_server
    interface_default_gw      = var.f5xc_interface_default_gw
    labels                    = var.f5xc_labels
  })
  interface_create_uri = format(var.f5xc_interface_create_uri, var.f5xc_namespace)
  interface_delete_uri = format(var.f5xc_interface_delete_uri, var.f5xc_namespace)
}