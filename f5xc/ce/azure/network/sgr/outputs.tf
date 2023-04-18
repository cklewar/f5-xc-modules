output "sgr" {
  value = {
    security_group_rules_slo = var.azure_security_group_rules_slo
    security_group_rules_sli = var.azure_security_group_rules_sli
  }
}