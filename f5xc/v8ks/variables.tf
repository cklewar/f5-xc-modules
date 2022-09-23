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

variable "f5xc_api_credential_type" {
  type    = string
  default = "KUBE_CONFIG"
}

variable "f5xc_virtual_site_refs" {
  type    = list(string)
  default = []
}

variable "f5xc_vk8s_provisioner_apply_timeout" {
  type    = string
  default = "120s"
}

variable "f5xc_vk8s_provisioner_destroy_timeout" {
  type    = string
  default = "30s"
}