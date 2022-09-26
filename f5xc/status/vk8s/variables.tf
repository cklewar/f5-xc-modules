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

variable "f5xc_site_get_uri" {
  type    = string
  default = "config/namespaces/%s/virtual_k8ss/%s"
}

variable "f5xc_vk8s_label_filter_uri" {
  type    = string
  default = "?label_filter=tf_vk8s_filter%3D%s"
}

variable "f5xc_vk8s_name" {
  type = string
}