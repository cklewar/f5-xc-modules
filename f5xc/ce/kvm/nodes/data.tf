data "template_file" "user_data" {
  template = file("${path.module}/cloudinit/user-data.tpl")
  vars     = {
    "site-registration-token"     = volterra_token.token.id
    "xc-environment-api-endpoint" = var.f5xc_reg_url
    "cluster-name"                = var.f5xc_cluster_name
    "host-name"                   = var.f5xc_node_name
    "latitude"                    = var.f5xc_cluster_latitude
    "longitude"                   = var.f5xc_cluster_longitude
    "certified-hw"                = var.f5xc_certified_hardware[var.f5xc_ce_gateway_type]
  }
}

data "template_file" "meta_data" {
  template = file("${path.module}/cloudinit/meta-data.tpl")
  vars     = {
    "host-name" = var.f5xc_node_name
  }
}
