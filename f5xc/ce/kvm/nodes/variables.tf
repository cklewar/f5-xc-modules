variable "is_multi_nic" {
  type = bool
}

variable "is_multi_node" {
  type = bool
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_qcow2_image" {
  type = string
}

variable "f5xc_node_name" {
  type = string
}

variable "f5xc_reg_url" {
  type    = string
  default = "ves.volterra.io"
}

variable "f5xc_namespace" {
  type = string
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
  type    = map(string)
  default = {
    ingress_gateway        = "kvm-voltmesh"
    ingress_egress_gateway = "kvm-regular-nic-voltmesh"
  }
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

variable "f5xc_kvm_site_nodes" {
  type = map(map(string))
  validation {
    condition     = length(var.f5xc_kvm_site_nodes) == 1 || length(var.f5xc_kvm_site_nodes) == 3
    error_message = "f5xc_kvm_site_nodes must be 1 or 3"
  }
}

variable "f5xc_registration_wait_time" {
  type    = number
  default = 60
}

variable "f5xc_registration_retry" {
  type    = number
  default = 20
}

variable "kvm_storage_pool" {
  type = string
  default = "default"
}

variable "kvm_instance_cpu_count" {
  type = number
  default = 4
}

variable "kvm_instance_memory_size" {
  type = number
  default = 16384  
}

variable "kvm_instance_outside_network_name" {
  type = string
  default = "default"
}

variable "kvm_instance_inside_network_name" {
  type = string
}
