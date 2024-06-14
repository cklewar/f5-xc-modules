variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_api_url" {
  type = string
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

variable "f5xc_cluster_name" {
  type = string
}

variable "f5xc_cluster_latitude" {
  type = number
}

variable "f5xc_cluster_longitude" {
  type = number
}

variable "f5xc_cluster_labels" {
  type = map(string)
  default = {}
}

variable "f5xc_certified_hardware" {
  type    = string
  default = "kvm-regular-nic-voltmesh"
}

variable "f5xc_qcow2_image" {
  type = string
}

variable "f5xc_reg_url" {
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
    condition = contains(["ingress_egress_gateway", "ingress_gateway"], var.f5xc_ce_gateway_type)
    error_message = format("Valid values for gateway_type: ingress_egress_gateway, ingress_gateway")
  }
}

variable "f5xc_ce_performance_enhancement_mode" {
  type = object({
    perf_mode_l7_enhanced = bool
    perf_mode_l3_enhanced = optional(object({
      jumbo_frame_enabled = bool
    }))
  })
  default = {
    perf_mode_l7_enhanced = true
  }
}

variable "f5xc_enable_offline_survivability_mode" {
  type    = bool
  default = false
}

variable "qemu_uri" {
  type = string
}

variable "f5xc_kvm_site_nodes" {
  type = map(map(string))
  validation {
    condition     = length(var.f5xc_kvm_site_nodes) == 1 || length(var.f5xc_kvm_site_nodes) == 3 || length(var.f5xc_kvm_site_nodes) == 0
    error_message = "f5xc_kvm_site_nodes must be 1 or 3"
  }
}

variable "f5xc_cluster_default_blocked_services" {
  type    = bool
  default = false
}

variable "kvm_storage_pool" {
  type = string
}

variable "kvm_instance_cpu_count" {
  type    = number
  default = 4
}

variable "kvm_instance_memory_size" {
  type    = number
  default = 16384
}

variable "kvm_instance_inside_network_name" {
  type = string
}

variable "kvm_instance_outside_network_name" {
  type = string
}

variable "status_check_type" {
  type    = string
  default = "token"
}

variable "f5xc_site_type_is_secure_mesh_site" {
  type    = bool
  default = true
}

variable "is_sensitive" {
  type = bool
}
