resource "null_resource" "apply_credential" {
  triggers = {
    MODULES_ROOT         = var.f5xc_api_credential_module_root
    tenant               = var.f5xc_tenant
    storage              = var.storage
    api_url              = var.f5xc_api_url
    api_token            = local.f5xc_api_token
    aws_region           = var.aws_region
    s3_key               = var.s3_key
    s3_bucket            = var.s3_bucket
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
      aws_region                 = var.aws_region
      storage                    = var.storage
      s3_key                     = var.s3_key
      s3_bucket                  = var.s3_bucket
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
      aws_region           = self.triggers.aws_region
      storage              = self.triggers.storage
      s3_key               = self.triggers.s3_key
      s3_bucket            = self.triggers.s3_bucket
      api_url              = self.triggers.api_url
      api_token            = self.triggers.api_token
      api_credentials_name = self.triggers.api_credentials_name
    }
  }
}
