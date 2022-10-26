resource "local_file" "site" {
  content  = local.content
  filename = format("%s/_out/%s_%s", path.module, var.f5xc_site_name, var.f5xc_site_payload_file)
}

resource "null_resource" "apply_site_update" {
  triggers = {
    manifest_sha1 = sha1(local.content)
  }

  provisioner "local-exec" {
    command     = format("curl -v -X 'PUT' '%s/%s' -H 'Content-Type: application/json' -H 'Authorization: APIToken %s' -d '%s'", var.f5xc_api_url, local.site_update_uri, var.f5xc_api_token, local.content)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }
}