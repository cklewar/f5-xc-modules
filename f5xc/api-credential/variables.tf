variable "f5xc_api_url" {
  type = string
}

variable "storage" {
  type    = string
  default = "internal"
}

variable "aws_region" {
  type    = string
  default = ""
}

variable "s3_bucket" {
  type    = string
  default = ""
}

variable "s3_key" {
  type    = string
  default = ""
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_credential_get_uri" {
  type    = string
  default = "web/namespaces/%s/api_credentials"
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type    = string
  default = "system"
}

variable "f5xc_api_credentials_name" {
  type = string
}

variable "f5xc_api_credential_password" {
  type    = string
  default = ""
}

variable "f5xc_api_credential_expiry_days" {
  type    = number
  default = 10
}

variable "f5xc_api_credential_type_kube_config" {
  type    = string
  default = "KUBE_CONFIG"
}

variable "f5xc_api_credential_type_api_certificate" {
  type    = string
  default = "API_CERTIFICATE"
}

variable "f5xc_api_credential_type" {
  type = string

  validation {
    condition     = contains(["KUBE_CONFIG", "API_CERTIFICATE", "API_TOKEN"], var.f5xc_api_credential_type)
    error_message = format("Valid values for f5xc_api_credential_type: API_CERTIFICATE, API_TOKEN, KUBE_CONFIG")
  }
}

variable "f5xc_virtual_k8s_namespace" {
  type    = string
  default = ""
}

variable "f5xc_virtual_k8s_name" {
  type    = string
  default = ""
}

variable "is_sensitive" {
  type        = bool
  default     = false
  description = "Whether to mask sensitive data in output or not"
}

variable "f5xc_api_credential_module_root" {
  type        = string
  description = "Path to XC modules directory"
}