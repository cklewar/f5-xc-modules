variable "slo_network" {
  type = string
}

variable "sli_network" {
  type = string
}

variable "f5xc_ce_gateway_type_ingress" {
  type    = string
  default = "ingress_gateway"
}

variable "f5xc_ce_gateway_type_ingress_egress" {
  type    = string
  default = "ingress_egress_gateway"
}

variable "f5xc_ce_gateway_type" {
  type = string
}

variable "f5xc_ce_slo_firewall" {
  type = object({
    rules = list(object({
      name        = string
      priority    = string
      description = string
      direction   = string
      target_tags = optional(list(string))
      ranges      = list(string)
      allow       = list(object({
        protocol = string
        ports    = optional(list(string))
      }))
      deny = list(object({
        protocol = string
        ports    = optional(list(string))
      }))
      log_config = optional(object({
        metadata = string
      }))
    }))
  })
  validation {
    condition     = alltrue([for elem in var.f5xc_ce_slo_firewall.rules : contains(["INGRESS", "EGRESS"], elem.direction)])
    error_message = "Invalid firewall rule direction"
  }
}

variable "f5xc_ce_sli_firewall" {
  type = object({
    rules = list(object({
      name        = string
      priority    = string
      description = string
      direction   = string
      target_tags = optional(list(string))
      ranges      = optional(list(string))
      allow       = list(object({
        protocol = string
        ports    = optional(list(string))
      }))
      deny = list(object({
        protocol = string
        ports    = optional(list(string))
      }))
      log_config = optional(object({
        metadata = string
      }))
    }))
  })
  validation {
    condition     = alltrue([for elem in var.f5xc_ce_sli_firewall.rules : contains(["INGRESS", "EGRESS"], elem.direction)])
    error_message = "Invalid firewall rule direction"
  }
}