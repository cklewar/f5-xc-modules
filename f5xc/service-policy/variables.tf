variable "f5xc_namespace" {
  type = string
}

variable "f5xc_service_policy_name" {
  type = string
}

variable "f5xc_service_policy_allow_all_requests" {
  type    = bool
  default = null
}

variable "f5xc_service_policy_deny_all_requests" {
  type    = bool
  default = null
}

variable "f5xc_service_policy_eval_algorithm" {
  type    = string
  default = "FIRST_MATCH"
  validation {
    condition     = contains(["FIRST_MATCH", "DENY_OVERRIDES", "DENY", "ALLOW"], var.f5xc_service_policy_eval_algorithm)
    error_message = "Eval algo must me one of 'FIRST_MATCH', 'DENY_OVERRIDES', 'DENY', 'ALLOW'"
  }
}

variable "f5xc_service_policy_any_server" {
  type    = bool
  default = true
}

variable "f5xc_service_policy_server_name" {
  type    = string
  default = ""
}

variable "server_name_matcher_exact_values" {
  type    = list(string)
  default = []
}

variable "server_name_matcher_regex_values" {
  type    = list(string)
  default = []
}

variable "f5xc_server_selector_expressions" {
  type    = list(string)
  default = []
}

variable "f5xc_service_policy_create_timeout" {
  type    = string
  default = "10s"
}

variable "f5xc_service_policy" {
  type = object({
    rules = optional(list(object({
      metadata = object({
        name        = string
        disable     = optional(bool)
        description = optional(string)
      })
      spec = optional(object({
        action           = optional(string)
        scheme           = optional(list(string), [])
        any_ip           = optional(bool)
        challenge_action = optional(string, "DEFAULT_CHALLENGE")
        any_client       = optional(bool)
        waf_action       = optional(object({
          none = optional(bool)
        }))
        asn_matcher = optional(object({
          asn_sets = optional(object({
            name      = optional(string)
            namespace = optional(string)
          }))
        }))
      }))
    })), [])
    allow_list = optional(object({
      country_list               = optional(list(string))
      tls_fingerprint_values     = optional(list(string))
      tls_fingerprint_classes    = optional(list(string), [])
      default_action_next_policy = optional(bool, null)
      asn_list                   = optional(object({
        as_numbers = optional(list(string), [])
      }), {})
      prefix_list = optional(object({
        prefixes = optional(list(string), [])
      }), {})
      ip_prefix_set = optional(list(object({
        name      = optional(string, null)
        tenant    = optional(string, null)
        namespace = optional(string, null)
      })), [])
    }), {})
    deny_list = optional(object({
      country_list               = optional(list(string), [])
      tls_fingerprint_values     = optional(list(string))
      tls_fingerprint_classes    = optional(list(string), [])
      default_action_next_policy = optional(bool, null)
      asn_list                   = optional(object({
        as_numbers = optional(list(string), [])
      }), {})
      prefix_list = optional(object({
        prefixes = optional(list(string), [])
      }), {})
      ip_prefix_set = optional(list(object({
        name      = optional(string, null)
        tenant    = optional(string, null)
        namespace = optional(string, null)
      })), [])
    }), {})
  })
}