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

resource "local_file" "api_credentials" {
  content  = local.api_credential_content
  filename = format("%s/_out/%s", path.module, var.f5xc_api_credentials_payload_file)

  lifecycle {
    create_before_destroy = true
  }
}

resource "null_resource" "apply_credential" {
  triggers = {
    manifest_sha1         = sha1(local.api_credential_content)
    api_url               = var.f5xc_api_url
    api_token             = var.f5xc_api_token
    delete_uri            = local.credential_delete_uri
    namespace             = var.f5xc_namespace
    name                  = var.f5xc_api_credentials_name
    virtual_k8s_namespace = var.f5xc_virtual_k8s_namespace
    virtual_k8s_name      = var.f5xc_virtual_k8s_name
    filename              = "${path.module}/_out/response.json"
  }

  provisioner "local-exec" {
    command     = format("curl -o ${self.triggers.filename} -X 'POST' https://playground.staging.volterra.us/api/web/namespaces/system/api_credentials -H 'Content-Type: application/json' -H 'Authorization: APIToken %s' -d '%s'", var.f5xc_api_token, local.api_credential_content)
    interpreter = ["/bin/bash", "-c"]
  }

  /*provisioner "local-exec" {
    when        = destroy
    command     = "${path.module}/scripts/delete.sh"
    on_failure  = continue
    environment = {
      api_token             = self.triggers.api_token
      api_url               = self.triggers.api_url
      delete_uri            = self.triggers.delete_uri
      namespace             = self.triggers.namespace
      virtual_k8s_namespace = self.triggers.virtual_k8s_namespace
      virtual_k8s_name      = self.triggers.virtual_k8s_name
    }
  }*/
}

resource "null_resource" "destroy" {
  depends_on = [local_file.api_credentials]
  triggers   = {
    api_url    = var.f5xc_api_url
    delete_uri = local.credential_delete_uri
    api_token  = var.f5xc_api_token
    namespace  = var.f5xc_namespace
    name       = jsondecode(data.local_file.response.content).name
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