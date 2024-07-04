variable "is_multi_nic" {
  type = bool
}

variable "is_multi_node" {
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
    condition     = length(var.f5xc_vsphere_site_nodes) == 1 || length(var.f5xc_vsphere_site_nodes) == 3
    error_message = "f5xc_vsphere_site_nodes must be 1 or 3"
  }
}

variable "f5xc_ova_image" {
  type    = string
  default = ""
}

variable "f5xc_node_name" {
  type = string
}

variable "f5xc_vsphere_instance_template" {
  type = string
}

variable "f5xc_reg_url" {
  type    = string
  default = "ves.volterra.io"
}

variable "f5xc_registration_wait_time" {
  type    = number
  default = 60
}

variable "f5xc_registration_retry" {
  type    = number
  default = 20
}

variable "f5xc_cluster_name" {
  type = string
}

variable "f5xc_cluster_latitude" {
  type = number
}

variable "f5xc_cluster_longitude" {
  type = number
}

variable "f5xc_certified_hardware" {
  type    = string
  default = "vmware-voltmesh"
}

variable "vsphere_host" {
  type = string
}

variable "vsphere_datastore" {
  type = string
}

variable "vsphere_instance_admin_password" {
  type = string
}

variable "vsphere_instance_network_adapter_type" {
  type = string
}

variable "vsphere_instance_inside_network_name" {
  type = string
}

variable "vsphere_instance_outside_network_name" {
  type = string
}

variable "vsphere_instance_outside_interface_name" {
  type    = string
  default = "eth0"
}

variable "vsphere_instance_outside_interface_role" {
  type    = string
  default = "public"
}

variable "vsphere_instance_outside_interface_ip_address" {
  type = string
}

variable "vsphere_instance_outside_interface_dhcp" {
  type = bool
}

variable "vsphere_instance_outside_interface_default_route" {
  type = string
}

variable "vsphere_instance_outside_interface_default_gateway" {
  type = string
}

variable "vsphere_instance_dns_servers" {
  type = object({
    primary   = string
    secondary = optional(string)
  })
}

variable "vsphere_instance_cpu_count" {
  type = number
}

variable "vsphere_instance_memory_size" {
  type = number
}

variable "vsphere_instance_guest_type" {
  type = string
}

variable "vsphere_datacenter" {
  type = string
}

variable "vsphere_cluster" {
  type = string
}

variable "vsphere_virtual_machine_disk_size" {
  type    = number
  default = 80
}