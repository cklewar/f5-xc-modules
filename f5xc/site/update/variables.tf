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

variable "f5xc_site_update_template_file" {
  type    = string
  default = "site.tftpl"
}

variable "f5xc_site_payload_file" {
  type    = string
  default = "site.json"
}

variable "f5xc_global_virtual_network" {
  type = string
}

variable "f5xc_site_update_uri" {
  type    = string
  default = "config/namespaces/%s/sites/%s"
}

variable "f5xc_site_name" {
  type = string
}

variable "f5xc_cluster_labels" {
  type    = map(string)
  default = {}
}