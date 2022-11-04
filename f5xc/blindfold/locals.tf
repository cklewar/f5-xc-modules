locals {
  f5xc_blindfold_policy_rule_payload = templatefile(format("%s/templates/%s", path.module, var.f5xc_policy_rule_payload_template), {
    tenant           = var.f5xc_tenant
    namespace        = var.f5xc_namespace
    regexValues      = var.f5xc_blindfold_secret_policy_rule_regex_values
    policy_rule_name = var.f5xc_blindfold_secret_policy_rule_name
  })

  f5xc_blindfold_policys_payload = templatefile(format("%s/templates/%s", path.module, var.f5xc_policy_payload_template), {
    tenant           = var.f5xc_tenant
    namespace        = var.f5xc_namespace
    policy_name      = var.f5xc_blindfold_secret_policy_name
    policy_rule_name = var.f5xc_blindfold_secret_policy_rule_name
  })

  f5xc_secret_management_secret_policy_rules_get_uri    = format(var.f5xc_secret_management_secret_policy_rules_get_uri, var.f5xc_namespace, var.f5xc_blindfold_secret_policy_rule_name)
  f5xc_secret_management_secret_policy_rules_post_uri   = format(var.f5xc_secret_management_secret_policy_rules_post_uri, var.f5xc_namespace)
  f5xc_secret_management_secret_policy_rules_delete_uri = format(var.f5xc_secret_management_secret_policy_rules_delete_uri, var.f5xc_namespace, var.f5xc_blindfold_secret_policy_rule_name)
  f5xc_secret_management_secret_policy_get_uri          = format(var.f5xc_secret_management_secret_policy_get_uri, var.f5xc_namespace, var.f5xc_blindfold_secret_policy_name)
  f5xc_secret_management_secret_policy_post_uri         = format(var.f5xc_secret_management_secret_policy_post_uri, var.f5xc_namespace)
  f5xc_secret_management_secret_policy_delete_uri       = format(var.f5xc_secret_management_secret_policy_delete_uri, var.f5xc_namespace, var.f5xc_blindfold_secret_policy_name)
}

