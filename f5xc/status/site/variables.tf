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
  default = "config/namespaces/%s/sites/%s"
}

variable "f5xc_site_name" {
  type = string
}