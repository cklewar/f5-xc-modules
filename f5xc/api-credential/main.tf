resource "volterra_api_credential" "credential" {
  name                  = var.f5xc_vk8s_api_credentials_name
  api_credential_type   = var.f5xc_api_credential_type
  virtual_k8s_namespace = var.f5xc_namespace
  virtual_k8s_name      = var.f5xc_vk8s_name
  lifecycle {
    ignore_changes = [name]
  }
}