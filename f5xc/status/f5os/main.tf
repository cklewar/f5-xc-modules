resource "terraform_data" "check_site_status_basic" {
  count = var.status_check_type == var.check_type_basic ? 1 : 0
  provisioner "local-exec" {
    command     = format("%s/scripts/check.sh %s %s %s %s %s", path.module, local.tenant_get_url, var.f5os_api_username, var.f5os_api_password, var.f5os_max_timeout, var.check_type_basic)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }
}