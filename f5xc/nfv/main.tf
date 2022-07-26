resource "local_file" "payload" {
  content  = local.manifest_content
  filename = format("%s/_out/%s", path.module, var.f5xc_nfv_payload_file)
}

resource "null_resource" "wait_for_tgw_online" {
  depends_on = [var.dependency]

  provisioner "local-exec" {
    command     = format("%s/scripts/check_tgw.sh %s %s %s", path.module, local.site_get_url, var.f5xc_api_token, var.f5xc_tenant)
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "null_resource" "apply_nfv" {
  depends_on = [var.dependency, null_resource.wait_for_tgw_online]
  triggers   = {
    manifest_sha1 = sha1(local.manifest_content)
    api_url       = var.f5xc_api_url
    api_token     = var.f5xc_api_token
    delete_uri    = local.nfv_delete_uri
    namespace     = var.f5xc_namespace
    name          = var.f5xc_nfv_name
  }

  provisioner "local-exec" {
    command     = format("curl -v -X 'POST' '%s/%s' -H 'Content-Type: application/json' -H 'Authorization: APIToken %s' -d '%s'", var.f5xc_api_url, local.nfv_create_uri, var.f5xc_api_token, local.manifest_content)
    interpreter = ["/bin/bash", "-c"]
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

resource "null_resource" "check_nfv_reachable" {
  depends_on = [null_resource.wait_for_tgw_online, null_resource.apply_nfv]
  provisioner "local-exec" {
    command     = format("%s/scripts/check_nfv.sh https://%s.%s", path.module, var.f5xc_nfv_node_name, var.f5xc_nfv_domain_suffix)
    interpreter = ["/bin/bash", "-c"]
  }
}