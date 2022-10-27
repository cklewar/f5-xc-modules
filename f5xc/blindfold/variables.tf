variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type    = string
  default = ""
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_uri_secret_management_secret_policys" {
  type    = string
  default = "secret_management/namespaces/system/secret_policys"
}

variable "f5xc_uri_secret_management_secret_policy_rules" {
  type    = string
  default = "secret_management/namespaces/system/secret_policy_rules"
}

variable "f5xc_policy_payload_template" {
  type    = string
  default = "policy.tftpl"
}

variable "f5xc_policy_rule_payload_template" {
  type    = string
  default = "rule.tftpl"
}

variable "f5xc_blindfold_policy_name" {
  type = string
  default = "ver-secret-policy-rule"
}

variable "f5xc_blindfold_policy_rule_name" {
  type = string
  default = "policy_rule_name"
}