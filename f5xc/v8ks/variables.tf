variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_vsite_refs_namespace" {
  type = string
}

variable "f5xc_vk8s_namespace" {
  type    = string
  default = "shared"
}

variable "f5xc_vk8s_name" {
  type = string
}

variable "f5xc_vk8s_description" {
  type    = string
  default = ""
}

variable "f5xc_vk8s_isolated" {
  type    = bool
  default = false
}

variable "f5xc_vk8s_default_flavor_name" {
  type    = string
  default = ""
}

variable "f5xc_virtual_site_refs" {
  type    = list(string)
  default = []
}

variable "f5xc_create_k8s_creds" {
  type    = bool
  default = false
}

variable "f5xc_namespace" {
  type    = string
  default = ""
}

variable "f5xc_k8s_credentials_name" {
  type    = string
  default = ""
}

variable "f5xc_labels" {
  type    = map(string)
  default = {}
}