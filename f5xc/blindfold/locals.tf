locals {
  f5xc_blindfold_policy_rule_payload = templatefile(format("%s/templates/%s", path.module, var.f5xc_policy_rule_payload_template), {
    tenant      = var.f5xc_tenant
    namespace   = var.f5xc_namespace
    policy_name = var.f5xc_blindfold_secret_policy_name
    regexValues = var.f5xc_blindfold_secret_policy_rule_regex_values
  })

  f5xc_blindfold_policys_payload = templatefile(format("%s/templates/%s", path.module, var.f5xc_policy_payload_template), {
    tenant           = var.f5xc_tenant
    namespace        = var.f5xc_namespace
    policy_name      = var.f5xc_blindfold_secret_policy_name
    policy_rule_name = var.f5xc_blindfold_secret_policy_rule_name
  })

  f5xc_blindfold_service_policy_delete_uri      = format("%s/%s", var.f5xc_api_url, format(var.f5xc_blindfold_secret_policy_delete_uri, var.f5xc_namespace, var.f5xc_blindfold_secret_policy_name))
  f5xc_blindfold_service_policy_rule_delete_uri = format("%s/%s", var.f5xc_api_url, format(var.f5xc_blindfold_secret_policy_rule_delete_uri, var.f5xc_namespace, var.f5xc_blindfold_secret_policy_rule_name))
}

