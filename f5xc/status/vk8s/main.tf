resource "null_resource" "check_vk8s_status" {
  count    = var.f5xc_api_token != "" ? 1 : 0
  triggers = {
    always = local.random_id
  }

  provisioner "local-exec" {
    command     = format("%s/scripts/check.sh %s %s %s %s %s %s", path.module, local.site_get_url, local.f5xc_api_token, local.f5xc_tenant, var.f5xc_max_timeout, local.site_get_url_filter, var.check_type_token)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }
}

resource "null_resource" "check_vk8s_status" {
  count    = var.f5xc_api_p12_cert != "" ? 1 : 0
  triggers = {
    always = local.random_id
  }

  provisioner "local-exec" {
    command     = format("%s/scripts/check.sh %s %s %s %s %s %s %s", path.module, local.site_get_url, var.f5xc_api_p12_cert, local.f5xc_tenant, var.f5xc_max_timeout, local.site_get_url_filter, var.check_type_token, var.f5xc_api_p12_cert_password)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }
}