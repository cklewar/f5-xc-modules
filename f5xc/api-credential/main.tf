resource "null_resource" "apply_credential" {
  triggers = {
    MODULES_ROOT         = var.f5xc_api_credential_module_root
    tenant               = var.f5xc_tenant
    api_url              = var.f5xc_api_url
    api_token            = local.f5xc_api_token
    api_credentials_name = var.f5xc_api_credentials_name
  }

  provisioner "local-exec" {
    command     = "${path.module}/scripts/create.sh"
    interpreter = ["/usr/bin/env", "bash", "-c"]
    on_failure  = fail
    environment = {
      MODULES_ROOT               = self.triggers.MODULES_ROOT
      tenant                     = var.f5xc_tenant
      api_url                    = var.f5xc_api_url
      api_token                  = local.f5xc_api_token
      virtual_k8s_name           = var.f5xc_virtual_k8s_name
      virtual_k8s_namespace      = var.f5xc_virtual_k8s_namespace
      api_credential_type        = var.f5xc_api_credential_type
      api_credentials_name       = var.f5xc_api_credentials_name
      api_credential_password    = var.f5xc_api_credential_password
      api_credential_expiry_days = var.f5xc_api_credential_expiry_days
    }
  }

  provisioner "local-exec" {
    command     = "ls -la ${var.f5xc_api_credential_module_root}"
    interpreter = ["/usr/bin/env", "bash", "-c"]
    on_failure  = fail
  }

  provisioner "local-exec" {
    command     = "ls -la ${var.f5xc_api_credential_module_root}/modules/f5xc/api-credential/_out/asstral-sesne8-smg-scale-test"
    interpreter = ["/usr/bin/env", "bash", "-c"]
    on_failure  = fail
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "${path.module}/scripts/delete.sh"
    interpreter = ["/usr/bin/env", "bash", "-c"]
    on_failure  = fail
    environment = {
      MODULES_ROOT         = self.triggers.MODULES_ROOT
      tenant               = self.triggers.tenant
      api_url              = self.triggers.api_url
      api_token            = self.triggers.api_token
      api_credentials_name = self.triggers.api_credentials_name
    }
  }
}
