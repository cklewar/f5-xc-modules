resource "null_resource" "create_secret_policy_rule" {
  triggers = {
    manifest_sha1 = sha1(local.f5xc_blindfold_policy_rule_payload)
    api_url       = var.f5xc_api_url
    api_token     = var.f5xc_api_token
    namespace     = var.f5xc_namespace
  }

  provisioner "local-exec" {
    command     = format("curl -v -X 'POST' '%s/%s' -H 'Content-Type: application/json' -H 'Authorization: APIToken %s' -d '%s'", var.f5xc_api_url, var.f5xc_uri_secret_management_secret_policy_rules, var.f5xc_api_token, local.f5xc_blindfold_policy_rule_payload)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "${path.module}/scripts/delete.sh"
    on_failure  = fail
    environment = {
      api_token = self.triggers.api_token
      api_url   = self.triggers.api_url
      namespace = self.triggers.namespace
    }
  }
}

resource "null_resource" "create_secret_policys" {
  depends_on = [null_resource.create_secret_policy_rule]
  triggers   = {
    manifest_sha1 = sha1(local.f5xc_blindfold_policys_payload)
    api_url       = var.f5xc_api_url
    api_token     = var.f5xc_api_token
    namespace     = var.f5xc_namespace
  }

  provisioner "local-exec" {
    command     = format("curl -v -X 'POST' '%s/%s' -H 'Content-Type: application/json' -H 'Authorization: APIToken %s' -d '%s'", var.f5xc_api_url, var.f5xc_uri_secret_management_secret_policys, var.f5xc_api_token, local.f5xc_blindfold_policys_payload)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "${path.module}/scripts/delete.sh"
    on_failure  = fail
    environment = {
      api_token = self.triggers.api_token
      api_url   = self.triggers.api_url
      namespace = self.triggers.namespace
    }
  }
}