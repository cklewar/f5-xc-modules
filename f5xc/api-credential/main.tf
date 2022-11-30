resource "null_resource" "apply_credential" {
  triggers = {
    api_url   = var.f5xc_api_url
    api_token = var.f5xc_api_token
    tenant    = var.f5xc_tenant
  }

  provisioner "local-exec" {
    command     = "${path.module}/scripts/create.sh"
    interpreter = ["/usr/bin/env", "bash", "-c"]
    on_failure  = fail
    environment = {
      api_url                 = var.f5xc_api_url
      api_token               = var.f5xc_api_token
      tenant                  = var.f5xc_tenant
      api_credentials_name    = var.f5xc_api_credentials_name
      virtual_k8s_name        = var.f5xc_virtual_k8s_name
      api_credential_type     = var.f5xc_api_credential_type
      api_credential_password = var.f5xc_api_credential_password
    }
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "${path.module}/scripts/delete.sh"
    interpreter = ["/usr/bin/env", "bash", "-c"]
    on_failure  = fail
    environment = {
      api_url   = self.triggers.api_url
      api_token = self.triggers.api_token
      tenant    = self.triggers.tenant
    }
  }
}