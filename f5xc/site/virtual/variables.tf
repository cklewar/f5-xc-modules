variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_cert" {
  type    = string
  default = ""
}

variable "f5xc_api_key" {
  type    = string
  default = ""
}

variable "f5xc_api_ca_cert" {
  type    = string
  default = ""
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_virtual_site_name" {
  type = string
}

variable "f5xc_virtual_site_selector_expression" {
  type = list(string)
  default = []
}

variable "f5xc_virtual_site_type" {
  type = string
  validation {
    condition     = contains(["REGIONAL_EDGE", "CUSTOMER_EDGE"], var.f5xc_virtual_site_type)
    error_message = format("Valid values for f5xc_virtual_site_type: REGIONAL_EDGE, CUSTOMER_EDGE")
  }
}