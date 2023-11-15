resource "volterra_service_policy" "service_policy" {
  name      = var.f5xc_service_policy_name
  algo      = var.f5xc_sp_search_algorithm
  namespace = var.f5xc_namespace

  rule_list {
    dynamic "rules" {
      for_each = var.f5xc_service_policy.rules
      content {
        spec {
          action           = rules.value.action
          any_ip           = rules.value.any_ip
          any_client       = rules.value.any_client
          challenge_action = rules.value.challenge_action
          asn_matcher {
            asn_sets {
              name      = rules.value.asn_matcher.asn_sets.name
              namespace = rules.value.asn_matcher.asn_sets.namespace
            }
          }
          waf_action {
            none = rules.value.waf_action.none
          }
        }
      }
    }
  }

  dynamic "allow_list" {
    for_each = var.f5xc_service_policy.allow_list
    content {
      country_list            = allow_list.value.country_list
      tls_fingerprint_classes = allow_list.value.tls_fingerprint_classes
      asn_list {
        as_numbers = allow_list.value.as_numbers
      }
      prefix_list {
        prefixes = allow_list.value.prefixes
      }
    }
  }

  dynamic "deny_list" {
    for_each = var.f5xc_service_policy.deny_list
    content {
      country_list            = deny_list.value.country_list
      tls_fingerprint_classes = deny_list.value.tls_fingerprint_classes
      asn_list {
        as_numbers = deny_list.value.as_numbers
      }
      prefix_list {
        prefixes = deny_list.value.prefixes
      }
    }
  }
}

resource "volterra_active_service_policies" "active_service_policies" {
  namespace = var.f5xc_namespace
  policies {
    name      = var.f5xc_service_policy_name
    namespace = var.f5xc_namespace
  }
}