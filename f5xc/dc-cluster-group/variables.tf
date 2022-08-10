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
  type    = string
  default = ""
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_dc_cluster_group_name" {
  type = string
}

variable "f5xc_dc_cluster_group_description" {
  type    = string
  default = ""
}

variable "f5xc_dc_cluster_group_labels" {
  type    = map(string)
  default = {}
}

