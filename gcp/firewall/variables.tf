variable "gcp_project_name" {
  type = string
}

variable "gcp_compute_firewall_name" {
  type = string
}

variable "gcp_compute_firewall_compute_network" {
  type = string
}

variable "gcp_compute_firewall_source_ranges" {
  type = list(string)
}

variable "gcp_compute_firewall_description" {
  type    = string
  default = ""
}

variable "gcp_compute_firewall_destination_ranges" {
  type    = list(string)
  default = []
}

variable "gcp_compute_firewall_priority" {
  type    = number
  default = 1000
}

variable "gcp_compute_firewall_direction" {
  type    = string
  default = "INGRESS"

  validation {
    condition     = contains(["INGRESS", "EGRESS"], var.gcp_compute_firewall_direction)
    error_message = "gcp_compute_firewall_direction valid options: INGRESS, EGRESS"
  }
}

variable "gcp_compute_firewall_disabled" {
  type    = bool
  default = false
}

variable "compute_firewall_allow_rules" {
  type = list(object({
    protocol = string
    ports    = optional(list(string))
  }))
  default = []
}

variable "compute_firewall_deny_rules" {
  type = list(object({
    protocol = string
    ports    = optional(list(string))
  }))
  default = []
}

variable "gcp_compute_firewall_target_tags" {
  type    = list(string)
  default = []
}