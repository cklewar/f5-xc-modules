variable "f5xc_api_url" {
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
