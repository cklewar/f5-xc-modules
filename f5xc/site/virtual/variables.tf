variable "f5xc_namespace" {
  type    = string
  default = "shared"
}

variable "f5xc_virtual_site_name" {
  type = string
}

variable "f5xc_virtual_site_selector_expression" {
  type    = list(string)
  default = []
}

variable "f5xc_virtual_site_type" {
  type = string
  validation {
    condition     = contains(["REGIONAL_EDGE", "CUSTOMER_EDGE"], var.f5xc_virtual_site_type)
    error_message = format("Valid values for f5xc_virtual_site_type: REGIONAL_EDGE, CUSTOMER_EDGE")
  }
}