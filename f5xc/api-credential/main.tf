/*resource "volterra_api_credential" "credential" {
  name                    = var.f5xc_api_credentials_name
  api_credential_type     = var.f5xc_api_credential_type
  api_credential_password = var.f5xc_api_credential_type == var.f5xc_api_credential_type_api_certificate && var.f5xc_api_credential_password != "" ? var.f5xc_api_credential_password : null
  virtual_k8s_namespace   = var.f5xc_api_credential_type == var.f5xc_api_credential_type_kube_config && var.f5xc_virtual_k8s_namespace != "" ? var.f5xc_virtual_k8s_namespace : null
  virtual_k8s_name        = var.f5xc_api_credential_type == var.f5xc_api_credential_type_kube_config && var.f5xc_virtual_k8s_name != "" ? var.f5xc_virtual_k8s_name : null
  expiry_days             = var.f5xc_api_credential_expiry_days
  lifecycle {
    ignore_changes = [name]
  }
}*/

/*resource "local_file" "api_credentials" {
  content  = local.api_credential_content
  filename = format("%s/_out/%s", path.module, var.f5xc_api_credentials_payload_file)

  lifecycle {
    create_before_destroy = true
  }
}*/

resource "null_resource" "apply_credential" {
  triggers = {
    manifest_sha1 = sha1(local.api_credential_content)
    api_url       = var.f5xc_api_url
    api_token     = var.f5xc_api_token
    uri           = local.credential_create_uri
    filename      = "${path.module}/_out/response.json"
  }

  provisioner "local-exec" {
    command     = format("curl -o ${self.triggers.filename} -X 'POST' 2>/dev/null %s/%s -H 'Content-Type: application/json' -H 'Authorization: APIToken %s' -d '%s'", self.triggers.api_url, self.triggers.uri, var.f5xc_api_token, local.api_credential_content)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }
}

resource "null_resource" "destroy" {
  # depends_on = [local_file.api_credentials]
  count      = length(data.local_file.response.*.content) > 0 ? 1 : 0
  triggers   = {
    api_url    = var.f5xc_api_url
    delete_uri = local.credential_delete_uri
    api_token  = var.f5xc_api_token
    namespace  = var.f5xc_namespace
    name       = jsondecode(data.local_file.response.*.content[0]).name
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "${path.module}/scripts/delete.sh"
    on_failure  = fail
    environment = {
      api_token  = self.triggers.api_token
      api_url    = self.triggers.api_url
      delete_uri = self.triggers.delete_uri
      namespace  = self.triggers.namespace
      name       = self.triggers.name
    }
  }
}