resource "null_resource" "check_vk8s_status" {
  triggers = {
    always = local.random_id
  }

  provisioner "local-exec" {
    command     = format("%s/scripts/check.sh %s %s %s %s", path.module, local.site_get_url, var.f5xc_api_token, var.f5xc_tenant, local.site_get_url_filter)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }
}