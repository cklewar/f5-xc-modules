locals {
  meta_data = templatefile("${path.module}/cloudinit/meta-data.tpl",
    {
      "host_name" = var.f5xc_node_name
    }
  )

  user_data = templatefile("${path.module}/cloudinit/user-data.tpl",
    {
      latitude                = var.f5xc_cluster_latitude
      host_name               = var.f5xc_node_name
      longitude               = var.f5xc_cluster_longitude
      cluster_name            = var.f5xc_cluster_name
      certified_hw            = var.f5xc_certified_hardware[var.f5xc_ce_gateway_type]
      maurice_endpoint        = var.maurice_endpoint
      maurice_mtls_endpoint   = var.maurice_mtls_endpoint
      site_registration_token = volterra_token.token.id
    }
  )
}