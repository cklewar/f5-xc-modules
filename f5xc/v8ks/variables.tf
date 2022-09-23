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