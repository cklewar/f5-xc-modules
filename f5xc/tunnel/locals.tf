locals {
  content = templatefile(format("%s/templates/%s", path.module, var.f5xc_tunnel_template_file), {
    namespace          = var.f5xc_namespace
    tunnel_name        = var.f5xc_tunnel_name
    tunnel_description = var.f5xc_tunnel_description
    clear_secret       = var.f5xc_tunnel_clear_secret
    remote_ip_address  = var.f5xc_tunnel_remote_ip_address
  })
  tunnel_create_uri = format(var.f5xc_tunnel_create_uri, var.f5xc_namespace)
  tunnel_delete_uri = format(var.f5xc_tunnel_delete_uri, var.f5xc_namespace)
}