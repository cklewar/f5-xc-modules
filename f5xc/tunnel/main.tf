resource "local_file" "tunnel" {
  content  = local.content
  filename = format("%s/_out/%s", path.module, var.f5xc_tunnel_payload_file)
}

resource "null_resource" "apply_tunnel" {
  triggers = {
    manifest_sha1 = sha1(local.content)
    api_url       = var.f5xc_api_url
    api_token     = var.f5xc_api_token
    delete_uri    = local.tunnel_delete_uri
    namespace     = var.f5xc_namespace
    tunnel_name   = var.f5xc_tunnel_name
  }

  provisioner "local-exec" {
    command     = format("curl -v -X 'POST' '%s/%s' -H 'Content-Type: application/json' -H 'Authorization: APIToken %s' -d '%s'", var.f5xc_api_url, local.tunnel_create_uri, var.f5xc_api_token, local.content)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "${path.module}/scripts/delete.sh"
    on_failure  = continue
    environment = {
      api_token      = self.triggers.api_token
      api_url        = self.triggers.api_url
      delete_uri     = self.triggers.delete_uri
      namespace      = self.triggers.namespace
      interface_name = self.triggers.tunnel_name
    }
  }
}