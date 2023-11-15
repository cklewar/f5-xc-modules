resource "volterra_service_policy" "service_policy" {
  name        = var.f5xc_service_policy_name
  algo        = var.f5xc_sp_search_algorithm
  namespace   = var.f5xc_namespace
  any_server  = var.f5xc_service_policy_any_server
  server_name = var.f5xc_service_policy_server_name

  server_name_matcher {
    exact_values = var.server_name_matcher_exact_values
    regex_values = var.server_name_matcher_regex_values
  }

  server_selector {
    expressions = var.f5xc_server_selector_expressions
  }

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
      country_list               = allow_list.value.country_list
      tls_fingerprint_classes    = allow_list.value.tls_fingerprint_classes
      default_action_next_policy = allow_list.value.default_action_next_policy
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
      country_list               = deny_list.value.country_list
      tls_fingerprint_classes    = deny_list.value.tls_fingerprint_classes
      default_action_next_policy = deny_list.value.default_action_next_policy
      asn_list {
        as_numbers = deny_list.value.as_numbers
      }
      prefix_list {
        prefixes = deny_list.value.prefixes
      }
      ip_prefix_set {
        name      = "test1"
        namespace = "staging"
        tenant    = "acmecorp"
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