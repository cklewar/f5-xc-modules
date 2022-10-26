resource "local_file" "payload" {
  content  = local.manifest_content
  filename = format("%s/_out/%s", path.module, var.f5xc_nfv_payload_file)
}

resource "null_resource" "apply_nfv" {
  triggers = {
    manifest_sha1 = sha1(local.manifest_content)
    api_url       = var.f5xc_api_url
    api_token     = var.f5xc_api_token
    delete_uri    = local.nfv_delete_uri
    namespace     = var.f5xc_namespace
    name          = var.f5xc_nfv_name
  }

  provisioner "local-exec" {
    command     = format("curl -v -X 'POST' '%s/%s' -H 'Content-Type: application/json' -H 'Authorization: APIToken %s' -d '%s'", var.f5xc_api_url, local.nfv_create_uri, var.f5xc_api_token, local.manifest_content)
    interpreter = ["/usr/bin/env", "bash", "-c"]
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

module "f5xc_nfv_wait_for_online" {
  depends_on             = [null_resource.apply_nfv]
  source                 = "../status/nfv"
  f5xc_api_token         = var.f5xc_api_token
  f5xc_api_url           = var.f5xc_api_url
  f5xc_namespace         = var.f5xc_namespace
  f5xc_tenant            = var.f5xc_tenant
  f5xc_nfv_name          = var.f5xc_nfv_name
  f5xc_nfv_node_name     = var.f5xc_nfv_node_name
  f5xc_nfv_domain_suffix = var.f5xc_nfv_domain_suffix
}