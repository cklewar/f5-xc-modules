locals {
  api_credential_content = templatefile(format("%s/templates/%s", path.module, var.f5xc_api_credential_template_file), {
    namespace             = var.f5xc_namespace
    tenant                = var.f5xc_tenant
    name                  = var.f5xc_api_credentials_name
    type                  = var.f5xc_api_credential_type
    expiration_days       = var.f5xc_api_credential_expiry_days
    password              = var.f5xc_api_credential_password
    virtual_k8s_namespace = var.f5xc_virtual_k8s_namespace
    virtual_k8s_name      = var.f5xc_virtual_k8s_name
  })
  credential_create_uri = format(var.f5xc_credential_create_uri, var.f5xc_namespace)
  credential_delete_uri = format(var.f5xc_credential_delete_uri, var.f5xc_namespace)
  credential_get_uri    = format(var.f5xc_credential_get_uri, var.f5xc_namespace)
}


