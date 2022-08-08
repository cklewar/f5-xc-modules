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
  default = ""
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_site_mesh_group_name" {
  type = string
}

variable "f5xc_site_mesh_group_description" {
  type    = string
  default = ""
}

variable "f5xc_tunnel_type" {
  type    = string
  default = "SITE_TO_SITE_TUNNEL_IPSEC"
}

variable "f5xc_site_2_site_connection_type" {
  type = string

  validation {
    condition     = contains(["spoke", "hub", "full_mesh"], var.f5xc_site_2_site_connection_type)
    error_message = format("Valid values for f5xc_site_2_site_connection_type: spoke, hub, full_mesh")
  }
}

variable "f5xc_site_2_site_connection_type_hub" {
  type    = string
  default = "hub"
}

variable "f5xc_site_site_hub_name" {
  type    = string
  default = ""
}

variable "f5xc_virtual_site_name" {
  type    = string
  default = ""
}