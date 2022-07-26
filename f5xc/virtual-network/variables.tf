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

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_vn_name" {
  type = string
}

variable "f5xc_ip_prefix_next_hop_interface" {
  type    = string
  default = ""
}

variable "f5xc_global_network" {
  type    = bool
  default = false
}

variable "f5xc_site_local_network" {
  type    = bool
  default = false
}

variable "f5xc_site_local_inside_network" {
  type    = bool
  default = false
}

variable "f5xc_ip_prefixes" {
  type    = list(string)
  default = []
}