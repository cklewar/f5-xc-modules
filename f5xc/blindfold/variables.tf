variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}
# secret_management/namespaces/system/secret_policy_rules
variable "f5xc_secret_management_secret_policy_rules_post_uri" {
  type    = string
  default = "secret_management/namespaces/%s/secret_policy_rules"
}

variable "f5xc_secret_management_secret_policy_rules_delete_uri" {
  type    = string
  default = "secret_management/namespaces/%s/secret_policy_rules/%s"
}

variable "f5xc_secret_management_secret_policy_rules_get_uri" {
  type    = string
  default = "secret_management/namespaces/%s/secret_policy_rules/%s"
}

variable "f5xc_secret_management_secret_policy_post_uri" {
  type    = string
  default = "secret_management/namespaces/%s/secret_policys"
}

variable "f5xc_secret_management_secret_policy_get_uri" {
  type    = string
  default = "secret_management/namespaces/%s/secret_policys/%s"
}

variable "f5xc_secret_management_secret_policy_delete_uri" {
  type    = string
  default = "secret_management/namespaces/%s/secret_policys/%s"
}

variable "f5xc_secret_management_public_key_get_uri" {
  type    = string
  default = "secret_management/get_public_key?key_version=0"
}

variable "f5xc_policy_payload_template" {
  type    = string
  default = "policy.tftpl"
}

variable "f5xc_policy_rule_payload_template" {
  type    = string
  default = "rule.tftpl"
}

variable "f5xc_blindfold_secret_policy_name" {
  type    = string
  default = "ver-secret-policy-rule"
}

variable "f5xc_blindfold_secret_policy_rule_name" {
  type    = string
  default = "policy_rule_name"
}

variable "f5xc_blindfold_secret_policy_rule_regex_values" {
  type    = string
  default = "ver\\..*\\.int.ves.io"
}