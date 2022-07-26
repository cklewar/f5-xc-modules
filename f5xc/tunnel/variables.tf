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

variable "f5xc_tunnel_template_file" {
  type    = string
  default = "tunnel.tftpl"
}

variable "f5xc_tunnel_payload_file" {
  type    = string
  default = "tunnel.json"
}

variable "f5xc_tunnel_create_uri" {
  type    = string
  default = "config/namespaces/%s/tunnels"
}

variable "f5xc_tunnel_delete_uri" {
  type    = string
  default = "config/namespaces/%s/tunnels"
}

variable "f5xc_tunnel_name" {
  type = string
}

variable "f5xc_tunnel_description" {
  type    = string
  default = ""
}

variable "f5xc_tunnel_clear_secret" {
  type = string
}

variable "f5xc_tunnel_remote_ip_address" {
  type = string
}