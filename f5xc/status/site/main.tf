resource "null_resource" "check_site_status" {
  provisioner "local-exec" {
    command     = format("%s/scripts/check.sh %s %s %s", path.module, local.site_get_url, local.f5xc_api_token, local.f5xc_tenant)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }
}