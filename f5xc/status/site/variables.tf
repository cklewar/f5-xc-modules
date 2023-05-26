variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type    = string
  default = ""
}

variable "f5xc_api_p12_cert" {
  type    = string
  default = ""
}

variable "f5xc_api_p12_cert_password" {
  type    = string
  default = ""
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_site_get_uri" {
  type    = string
  default = "config/namespaces/%s/sites/%s"
}

variable "check_type_token" {
  type    = string
  default = "token"
}

variable "check_type_cert" {
  type    = string
  default = "cert"
}

variable "f5xc_site_name" {
  type = string
}

variable "f5xc_max_timeout" {
  type    = number
  default = 3600
}

variable "is_sensitive" {
  type        = bool
  default     = false
  description = "Whether to mask sensitive data in output or not"
}