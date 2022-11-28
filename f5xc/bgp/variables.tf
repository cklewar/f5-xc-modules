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

variable "f5xc_bgp_name" {
  type = string
}

variable "f5xc_bgp_asn" {
  type = string
}

variable "f5xc_site_name" {
  type = string
}

variable "f5xc_bgp_network_type" {
  type    = string
  default = "VIRTUAL_NETWORK_SITE_LOCAL"
}

variable "f5xc_bgp_description" {
  type = string
}

variable "f5xc_bgp_router_id_type" {
  type    = string
  default = "BGP_ROUTER_ID_FROM_INTERFACE"
}

variable "f5xc_bgp_peer_name" {
  type = string
}

variable "f5xc_bgp_peer_asn" {
  type = string
}

variable "f5xc_bgp_peer_address" {
  type = string
}

variable "f5xc_bgp_port" {
  type    = number
  default = 179
}

variable "f5xc_bgp_interface_name" {
  type = string
}

variable "f5xc_bgp_local_address" {
  type = bool
  default = true
}

variable "f5xc_bgp_target_service" {
  type = string
  default = "frr"
}