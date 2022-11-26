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