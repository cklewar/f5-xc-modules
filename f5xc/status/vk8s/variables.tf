variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type    = string
  default = ""
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_vk8s_get_uri" {
  type    = string
  default = "config/namespaces/%s/virtual_k8ss/%s?response_format=GET_RSP_FORMAT_DEFAULT"
}

variable "f5xc_vk8s_get_uri_filter" {
  type    = string
  default = "config/namespaces/%s/virtual_k8ss?label_filter=tf_vk8s_filter=%s"
}

variable "f5xc_vk8s_name" {
  type = string
}

variable "check_type_token" {
  type    = string
  default = "token"
}

variable "check_type_cert" {
  type    = string
  default = "cert"
}

variable "f5xc_max_timeout" {
  type    = number
  default = 120
}

variable "f5xc_api_p12_cert" {
  type    = string
  default = ""
}

variable "f5xc_api_p12_cert_password" {
  type    = string
  default = ""
}

variable "is_sensitive" {
  type        = bool
  default     = false
  description = "Whether to mask sensitive data in output or not"
}
