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

variable "f5xc_interface_type_tunnel_interface" {
  type = string
  default = "tunnel_interface"
}

variable "f5xc_interface_type" {
  type = string

  validation {
    condition = contains([
      "ethernet_interface", "dedicated_management_interface", "dedicated_interface", "tunnel_interface"
    ], var.f5xc_interface_type)
    error_message = "Allowed values for input_parameter are 'ethernet_interface', 'dedicated_management_interface', 'dedicated_interface', 'tunnel_interface'."
  }
}

variable "f5xc_interface_name" {
  type = string
}

variable "f5xc_tunnel_name" {
  type = string
}

variable "f5xc_node_name" {
  type = string
}

variable "f5xc_interface_static_ip" {
  type = string
}

variable "f5xc_mtu" {
  type    = string
  default = "1450"
}

variable "f5xc_site_local_network" {
  type    = bool
  default = true
}

variable "f5xc_cluster" {
  type    = bool
  default = false
}

variable "f5xc_site_local_inside_network" {
  type    = bool
  default = false
}

variable "f5xc_interface_template_file" {
  type    = string
  default = "interface.tftpl"
}

variable "f5xc_interface_description" {
  type    = string
  default = ""
}

variable "f5xc_interface_create_uri" {
  type    = string
  default = "config/namespaces/%s/network_interfaces"
}

variable "f5xc_interface_delete_uri" {
  type    = string
  default = "config/namespaces/%s/network_interfaces"
}

variable "f5xc_interface_payload_file" {
  type    = string
  default = "interface.json"
}