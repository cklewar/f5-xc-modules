variable "butane_variant" {
  type    = string
  default = "fcos"
}

variable "butane_version" {
  type    = string
  default = "1.5.0"
}

variable "k0s_version" {
  type    = string
  default = "v1.26.3+k0s.0"
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_site_name" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}