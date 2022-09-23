resource "volterra_api_credential" "credential" {
  name                    = var.f5xc_api_credentials_name
  api_credential_type     = var.f5xc_api_credential_type
  api_credential_password = var.f5xc_api_credential_type == var.f5xc_api_credential_type_api_certificate && var.f5xc_api_credential_password != "" ? var.f5xc_api_credential_password : null
  virtual_k8s_namespace   = var.f5xc_api_credential_type == var.f5xc_api_credential_type_kube_config && var.f5xc_virtual_k8s_namespace != "" ? var.f5xc_virtual_k8s_namespace : null
  virtual_k8s_name        = var.f5xc_api_credential_type == var.f5xc_api_credential_type_kube_config && var.f5xc_virtual_k8s_name != "" ? var.f5xc_virtual_k8s_name : null
  expiry_days             = var.f5xc_api_credential_expiry_days != 0 ? var.f5xc_api_credential_expiry_days : null
  lifecycle {
    ignore_changes = [name]
  }
}