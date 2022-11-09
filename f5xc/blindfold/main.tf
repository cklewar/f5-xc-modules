resource "null_resource" "action_secret_policy_rule" {
  triggers = {
    api_url                 = var.f5xc_api_url
    api_token               = var.f5xc_api_token
    namespace               = var.f5xc_namespace
    delete_uri              = local.f5xc_secret_management_secret_policy_rules_delete_uri
    manifest_sha1           = sha1(local.f5xc_blindfold_policy_rule_payload)
    secret_policy_rule_name = var.f5xc_blindfold_secret_policy_rule_name
  }

  provisioner "local-exec" {
    command     = format("curl -v -X 'POST' '%s/%s' -H 'Content-Type: application/json' -H 'Authorization: APIToken %s' -d '%s'", var.f5xc_api_url, local.f5xc_secret_management_secret_policy_rules_post_uri, var.f5xc_api_token, local.f5xc_blindfold_policy_rule_payload)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "${path.module}/scripts/delete.sh"
    on_failure  = fail
    environment = {
      name       = self.triggers.secret_policy_rule_name
      api_url    = self.triggers.api_url
      api_token  = self.triggers.api_token
      namespace  = self.triggers.namespace
      delete_uri = self.triggers.delete_uri
    }
  }
}

resource "null_resource" "action_secret_policys" {
  depends_on = [null_resource.action_secret_policy_rule]
  triggers   = {
    name          = var.f5xc_blindfold_secret_policy_name
    api_url       = var.f5xc_api_url
    api_token     = var.f5xc_api_token
    namespace     = var.f5xc_namespace
    delete_uri    = local.f5xc_secret_management_secret_policy_delete_uri
    manifest_sha1 = sha1(local.f5xc_blindfold_policys_payload)
  }

  provisioner "local-exec" {
    command     = format("curl -v -X 'POST' '%s/%s' -H 'Content-Type: application/json' -H 'Authorization: APIToken %s' -d '%s'", var.f5xc_api_url, local.f5xc_secret_management_secret_policy_post_uri, var.f5xc_api_token, local.f5xc_blindfold_policys_payload)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "${path.module}/scripts/delete.sh"
    on_failure  = fail
    environment = {
      name       = self.triggers.name
      api_url    = self.triggers.api_url
      api_token  = self.triggers.api_token
      namespace  = self.triggers.namespace
      delete_uri = self.triggers.delete_uri
    }
  }
}