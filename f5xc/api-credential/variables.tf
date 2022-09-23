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

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_api_credentials_name" {
  type = string
}

variable "f5xc_api_credential_type" {
  type    = string
  default = "KUBE_CONFIG"

  validation {
    condition = contains(["KUBE_CONFIG"], var.f5xc_api_credential_type)
    error_message = format("Valid values for f5xc_api_credential_type: KUBE_CONFIG")
  }
}