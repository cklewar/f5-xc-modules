variable "gcp_project_name" {
  type = string
}

variable "gcp_compute_network_auto_create_subnetworks" {
  type    = bool
  default = true
}

variable "gcp_compute_network_mtu" {
  type    = number
  default = 1460

  validation {
    condition     = var.gcp_compute_network_mtu >= 1460 && var.gcp_compute_network_mtu <= 1500
    error_message = format("The minimum value for this field is 1460 and the maximum value is 1500 bytes")
  }
}

variable "gcp_compute_network_routing_mode" {
  type    = string
  default = ""

  validation {
    condition = contains([
      "REGIONAL", "GLOBAL", ""
    ], var.gcp_compute_network_routing_mode)
    error_message = format("Valid values for gcp_compute_network_routing_mode: REGIONAL, GLOBAL")
  }
}

variable "gcp_compute_network_delete_default_routes_on_create" {
  type    = bool
  default = false
}

variable "gcp_compute_network_name" {
  type = string
}