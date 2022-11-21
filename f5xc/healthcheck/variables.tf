variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_healthcheck_name" {
  type = string
}

variable "f5xc_healthcheck_use_origin_server_name" {
  type    = bool
  default = true
}

variable "f5xc_healthcheck_path" {
  type    = string
  default = "/"
}

variable "f5xc_healthcheck_healthy_threshold" {
  type    = number
  default = 1
}

variable "f5xc_healthcheck_interval" {
  type    = number
  default = 15
}

variable "f5xc_healthcheck_timeout" {
  type    = number
  default = 1
}

variable "f5xc_healthcheck_unhealthy_threshold" {
  type    = number
  default = 2
}

variable "f5xc_healthcheck_use_http2" {
  type    = bool
  default = false
}

variable "f5xc_healthcheck_request_headers_to_remove" {
  type    = list(string)
  default = []
}

variable "f5xc_f5xc_healthcheck_type_http" {
  type    = string
  default = "http"
}

variable "f5xc_f5xc_healthcheck_type_tcp" {
  type    = string
  default = "tcp"
}

variable "f5xc_healthcheck_type" {
  type    = string
  default = "http"

  validation {
    condition     = contains(["http", "tcp"], var.f5xc_healthcheck_type)
    error_message = format("Valid values for f5xc_healthcheck_type: http, tcp")
  }
}

variable "f5xc_healthcheck_expected_response" {
  type    = string
  default = ""
}

variable "f5xc_healthcheck_send_payload" {
  type    = string
  default = ""
}

variable "f5xc_healthcheck_http_host_header" {
  type    = string
  default = ""
}

variable "f5xc_healthcheck_http_headers" {
  type    = map(string)
  default = {}
}