resource "terraform_data" "check_site_status_token" {
  count = var.status_check_type == var.check_type_token ? 1 : 0
  provisioner "local-exec" {
    command     = format("%s/scripts/check.sh %s %s %s %s %s", path.module, local.site_get_url, local.f5xc_api_token, local.f5xc_tenant, var.f5xc_max_timeout, var.check_type_token)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }
}

resource "terraform_data" "check_site_status_cert" {
  count = var.status_check_type == var.check_type_cert ? 1 : 0
  provisioner "local-exec" {
    command     = format("%s/scripts/check.sh %s %s %s %s %s \"%s\"", path.module, local.site_get_url, var.f5xc_api_p12_file, local.f5xc_tenant, var.f5xc_max_timeout, var.check_type_cert, var.f5xc_api_p12_cert_password)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }
  triggers_replace = timestamp()
}