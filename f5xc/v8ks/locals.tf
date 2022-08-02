locals {
  manifest_content = templatefile(format("%s/manifest/manifest.tpl", path.module), {
    namespace = var.f5xc_namespace
  })
  kubectl_secret_registry_type     = var.kubectl_secret_registry_type
  kubectl_secret_registry_server   = var.kubectl_secret_registry_server
  kubectl_secret_name              = var.kubectl_secret_name
  kubectl_secret_registry_username = var.kubectl_secret_registry_username
  kubectl_secret_registry_password = var.kubectl_secret_registry_password
  kubectl_secret_registry_email    = var.kubectl_secret_registry_email
}
