variable "f5xc_tenant" {
  type      = string
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
  type    = bool
  default = true
}

variable "f5xc_bgp_target_service" {
  type    = string
  default = "frr"
}

variable "is_sensitive" {
  type    = bool
  default = false
}