variable "f5xc_namespace" {
  type = string
}

variable "f5xc_service_policy_name" {
  type = string
}

variable "f5xc_sp_search_algorithm" {
  type    = string
  default = "FIRST_MATCH"
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

variable "f5xc_service_policy" {
  type = object({
    rules = optional(list(object({
      metadata = object({
        name = string
      })
      spec = optional(object({
        action           = optional(string)
        any_ip           = optional(bool)
        challenge_action = optional(string, "DEFAULT_CHALLENGE")
        any_client       = optional(bool)
        waf_action       = optional(object({
          none = optional(bool)
        }))
        asn_mather = optional(object({
          asn_sets = optional(object({
            name      = optional(string)
            namespace = optional(string)
          }))
        }))
      }))
    })))
    allow_list = optional(object({
      default_action_next_policy = optional(bool)
      asn_list                   = optional(object({
        as_numbers = optional(list(string), [])
      }))
      prefix_list = optional(object({
        prefixes = optional(list(string), [])
      }))
      ip_prefix_set = optional(object({
        name      = optional(string)
        tenant    = optional(string)
        namespace = optional(string)
      }))
      country_list            = optional(list(string), [])
      tls_fingerprint_values  = optional(list(string), [])
      tls_fingerprint_classes = optional(list(string), [])
    }))
    deny_list = optional(object({
      asn_list = optional(object({
        as_numbers = optional(list(string), [])
      }))
      prefix_list = optional(object({
        prefixes = optional(list(string), [])
      }))
      ip_prefix_set = optional(object({
        name      = optional(string)
        tenant    = optional(string)
        namespace = optional(string)
      }))
      country_list            = optional(list(string), [])
      tls_fingerprint_classes = optional(list(string), [])
    }))
  })
}