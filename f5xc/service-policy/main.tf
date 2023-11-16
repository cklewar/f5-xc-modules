resource "volterra_service_policy" "service_policy" {
  name               = var.f5xc_service_policy_name
  algo               = var.f5xc_service_policy_eval_algorithm
  namespace          = var.f5xc_namespace
  any_server         = var.f5xc_service_policy_any_server
  server_name        = var.f5xc_service_policy_server_name
  allow_all_requests = var.f5xc_service_policy_allow_all_requests
  deny_all_requests  = var.f5xc_service_policy_deny_all_requests

  server_name_matcher {
    exact_values = var.server_name_matcher_exact_values
    regex_values = var.server_name_matcher_regex_values
  }

  server_selector {
    expressions = var.f5xc_server_selector_expressions
  }

  rule_list {
    dynamic "rules" {
      for_each = {for idx, v in var.f5xc_service_policy.rules : idx => v}
      content {
        metadata {
          name        = var.f5xc_service_policy.rules[rules.key].metadata.name
          disable     = var.f5xc_service_policy.rules[rules.key].metadata.disable
          description = var.f5xc_service_policy.rules[rules.key].metadata.description
        }
        spec {
          action           = var.f5xc_service_policy.rules[rules.key].spec.action
          scheme           = var.f5xc_service_policy.rules[rules.key].spec.scheme
          any_ip           = var.f5xc_service_policy.rules[rules.key].spec.any_ip
          any_client       = var.f5xc_service_policy.rules[rules.key].spec.any_client
          challenge_action = var.f5xc_service_policy.rules[rules.key].spec.challenge_action
          dynamic "waf_action" {
            for_each = var.f5xc_service_policy.rules[rules.key].spec.waf_action != null ? var.f5xc_service_policy.rules[rules.key].spec.waf_action : {}
            content {
              none = var.f5xc_service_policy.rules[rules.key].spec.waf_action.none
            }
          }
          dynamic "asn_matcher" {
            for_each = var.f5xc_service_policy.rules[rules.key].spec.asn_matcher != null ? var.f5xc_service_policy.rules[rules.key].spec.asn_matcher : {}
            content {
              asn_sets {
                name      = var.f5xc_service_policy.rules[rules.key].spec.asn_matcher.asn_sets.name
                namespace = var.f5xc_service_policy.rules[rules.key].spec.asn_matcher.asn_sets.namespace
              }
            }
          }
        }
      }
    }
  }

  allow_list {
    country_list               = var.f5xc_service_policy.allow_list.country_list
    tls_fingerprint_classes    = var.f5xc_service_policy.allow_list.tls_fingerprint_classes
    default_action_next_policy = var.f5xc_service_policy.allow_list.default_action_next_policy
    asn_list {
      as_numbers = var.f5xc_service_policy.allow_list.asn_list.as_numbers
    }
    prefix_list {
      prefixes = var.f5xc_service_policy.allow_list.prefix_list.prefixes
    }
    dynamic "ip_prefix_set" {
      for_each = var.f5xc_service_policy.allow_list.ip_prefix_set
      content {
        name      = ip_prefix_set.name
        tenant    = ip_prefix_set.tenant
        namespace = ip_prefix_set.namespace
      }
    }
  }

  deny_list {
    country_list               = var.f5xc_service_policy.deny_list.country_list
    tls_fingerprint_classes    = var.f5xc_service_policy.deny_list.tls_fingerprint_classes
    default_action_next_policy = var.f5xc_service_policy.deny_list.default_action_next_policy
    asn_list {
      as_numbers = var.f5xc_service_policy.deny_list.asn_list.as_numbers
    }
    prefix_list {
      prefixes = var.f5xc_service_policy.deny_list.prefix_list.prefixes
    }
    dynamic "ip_prefix_set" {
      for_each = var.f5xc_service_policy.deny_list.ip_prefix_set
      content {
        name      = ip_prefix_set.name
        tenant    = ip_prefix_set.tenant
        namespace = ip_prefix_set.namespace
      }
    }
  }
}

resource "time_sleep" "wait_n_seconds" {
  depends_on      = [volterra_service_policy.service_policy]
  create_duration = var.f5xc_service_policy_create_timeout
}

resource "null_resource" "next" {
  depends_on = [time_sleep.wait_n_seconds]
}

resource "volterra_active_service_policies" "active_service_policies" {
  namespace = var.f5xc_namespace
  policies {
    name      = var.f5xc_service_policy_name
    namespace = var.f5xc_namespace
  }
}