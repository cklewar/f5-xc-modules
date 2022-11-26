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

resource "null_resource" "apply_credential" {
  provisioner "local-exec" {
    command     = "${path.module}/scripts/script.py post ${var.f5xc_api_url} ${var.f5xc_api_token} ${var.f5xc_tenant} -n ${var.f5xc_api_credentials_name} -v ${ var.f5xc_virtual_k8s_name} -c ${var.f5xc_api_credential_type_kube_config}"
    interpreter = ["/usr/bin/env", "python3"]
    on_failure  = fail
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "${path.module}/scripts/script.py delete ${var.f5xc_api_url} ${var.f5xc_api_token} ${var.f5xc_tenant}"
    interpreter = ["/usr/bin/env", "python3"]
    on_failure  = fail
  }
}