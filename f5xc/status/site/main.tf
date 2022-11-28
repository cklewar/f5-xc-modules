resource "null_resource" "check_site_status" {
  /*triggers = {
    always = local.random_id
  }*/

  provisioner "local-exec" {
    command     = format("%s/scripts/check.sh %s %s %s", path.module, local.site_get_url, var.f5xc_api_token, var.f5xc_tenant)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }
}