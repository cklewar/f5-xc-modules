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

variable "f5xc_site_type_azure" {
  type    = string
  default = "azure"
}

variable "f5xc_site_type_gcp" {
  type    = string
  default = "gcp"
}

variable "f5xc_site_type_aws" {
  type    = string
  default = "aws"
}

variable "f5xc_site_type_vsphere" {
  type    = string
  default = "vmware"
}

variable "f5xc_site_type" {
  type = string
  validation {
    condition = contains(["vsphere", "aws", "gcp", "azure"], var.f5xc_site_type)
  }
}

variable "f5xc_secure_mesh_site_nodes" {
  type = map(map(string))
  validation {
    condition     = length(var.f5xc_secure_mesh_site_nodes) == 1 || length(var.f5xc_secure_mesh_site_nodes) == 3
    error_message = "f5xc_secure_mesh_site_nodes must be 1 or 3"
  }
}

variable "f5xc_site_type_certified_hw" {
  type    = map(string)
  default = {
    "aws"     = "aws-voltmesh"
    "gcp"     = "gcp-voltmesh"
    "azure"   = "azure-voltmesh"
    "vsphere" = "vmware-voltmesh"
  }
}

variable "f5xc_cluster_name" {
  type = string
}

variable "f5xc_cluster_labels" {
  type = map(string)
}

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

variable "f5xc_site_name" {
  type = string
}

variable "f5xc_site_latitude" {
  type    = number
  default = 37.4
}

variable "f5xc_site_longitude" {
  type    = number
  default = -121.9
}

variable "f5xc_site_vsphere_public_default_gateway" {
  type = string
}

variable "f5xc_site_vsphere_public_default_route" {
  type = string
}

variable "f5xc_site_vsphere_guest_type" {
  type    = string
  default = "centos64Guest"
}

variable "f5xc_site_vsphere_cpu_count" {
  type    = number
  default = 4
}

variable "f5xc_site_vsphere_memory" {
  type    = number
  default = 16384
}

variable "f5xc_site_vsphere_outside_network" {
  type    = string
  default = "VM Network"
}

variable "f5xc_site_vsphere_dns_servers" {
  type    = map(string)
  default = {
    primary   = "8.8.8.8"
    secondary = "8.8.4.4"
  }
}

variable "f5xc_ves_reg_url" {
  type    = string
  default = "ves.volterra.io"
}

variable "f5xc_site_vsphere_vm_template" {
  type = string
}

variable "f5xc_site_username" {
  type = string
}

variable "f5xc_site_password" {
  type = string
}

variable "f5xc_site_vsphere_server" {
  type    = string
  default = ""
}

variable "f5xc_site_vsphere_datacenter" {
  type    = string
  default = ""
}

variable "f5xc_site_vsphere_cluster" {
  type    = string
  default = ""
}