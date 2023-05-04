variable "is_sensitive" {
  type = bool
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_ce_gateway_type_ingress" {
  type    = string
  default = "ingress_gateway"
}

variable "f5xc_ce_gateway_type_ingress_egress" {
  type    = string
  default = "ingress_egress_gateway"
}

variable "f5xc_ce_gateway_type" {
  type = string
  validation {
    condition     = contains(["ingress_egress_gateway", "ingress_gateway"], var.f5xc_ce_gateway_type)
    error_message = format("Valid values for gateway_type: ingress_egress_gateway, ingress_gateway")
  }
}

variable "f5xc_vsphere_site_nodes" {
  type = map(map(string))
  validation {
    condition     = length(var.f5xc_vsphere_site_nodes) == 1 || length(var.f5xc_vsphere_site_nodes) == 3 || length(var.f5xc_vsphere_site_nodes) == 0
    error_message = "f5xc_vsphere_site_nodes must be 1 or 3"
  }
}

variable "f5xc_cluster_name" {
  type = string
}

variable "f5xc_site_latitude" {
  type = number
}

variable "f5xc_site_longitude" {
  type = number
}

variable "f5xc_certified_hardware" {
  type    = string
  default = "vmware-voltmesh"
}

variable "f5xc_vsphere_instance_template" {
  type    = string
  default = ""
}

variable "vsphere_instance_cpu_count" {
  type    = number
  default = 4
}

variable "vsphere_instance_memory_size" {
  type    = number
  default = 16384
}

variable "vsphere_instance_inside_network_name" {
  type = string
}

variable "vsphere_instance_outside_network_name" {
  type = string
}

variable "vsphere_instance_outside_interface_default_route" {
  type = string
}

variable "vsphere_instance_outside_interface_default_gateway" {
  type = string
}

variable "vsphere_instance_admin_password" {
  type = string
}

variable "vsphere_instance_dns_servers" {
  type = object({
    primary   = string
    secondary = optional(string)
  })
}

variable "vsphere_cluster" {
  type = string
}

variable "vsphere_datacenter" {
  type = string
}

variable "vsphere_instance_guest_type" {
  type    = string
  default = "centos64Guest"
}