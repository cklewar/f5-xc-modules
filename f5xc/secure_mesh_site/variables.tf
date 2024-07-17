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

variable "f5xc_cluster_labels" {
  type = map(string)
}

variable "f5xc_nodes" {
  type = list(object({
    name      = string
    public_ip = optional(string)
  }))
}

variable "f5xc_cluster_latitude" {
  type = number
}

variable "f5xc_cluster_longitude" {
  type = number
}

variable "f5xc_annotations" {
  type    = map(string)
  default = {}
}

variable "f5xc_enable_offline_survivability_mode" {
  type    = bool
  default = false
}

variable "f5xc_ce_performance_enhancement_mode" {
  type = object({
    perf_mode_l7_enhanced = bool
    perf_mode_l3_enhanced = optional(object({
      jumbo_frame_enabled = bool
    }))
  })
}

variable "f5xc_site_type_certified_hw" {
  type = object({
    aws    = map(string)
    gcp    = map(string)
    azure  = map(string)
    kvm    = map(string)
    vmware = map(string)
  })
  default = {
    aws = {
      ingress_gateway        = "aws-byol-voltmesh"
      ingress_egress_gateway = "aws-byol-multi-nic-voltmesh"
    }
    gcp = {
      ingress_gateway        = "gcp-byol-voltmesh"
      ingress_egress_gateway = "gcp-byol-multi-nic-voltmesh"
    }
    azure = {
      ingress_gateway        = "azure-byol-voltmesh"
      ingress_egress_gateway = "azure-byol-multi-nic-voltmesh"
    }
    kvm = {
      ingress_gateway        = "kvm-voltmesh"
      ingress_egress_gateway = "kvm-multi-nic-voltmesh"
    }
    vmware = {
      ingress_gateway        = "vmware-voltmesh"
      ingress_egress_gateway = "vmware-voltmesh"
    }
  }
}

variable "f5xc_ce_gateway_type" {
  type = string
  validation {
    condition = contains([
      "ingress_egress_gateway", "ingress_gateway",
    ], var.f5xc_ce_gateway_type)
    error_message = format("Valid values for gateway_type: ingress_egress_gateway, ingress_gateway")
  }
}

variable "f5xc_cluster_no_bond_devices" {
  type    = bool
  default = true
}

variable "f5xc_cluster_default_blocked_services" {
  type    = bool
  default = true
}

variable "f5xc_cluster_logs_streaming_disabled" {
  type    = string
  default = false
}

variable "f5xc_cluster_default_network_config" {
  type    = bool
  default = true
}

variable "f5xc_cluster_worker_nodes" {
  type    = list(string)
  default = []
}

variable "f5xc_default_os_version" {
  type    = bool
  default = true
}

variable "f5xc_operating_system_version" {
  type    = string
  default = null
}

variable "f5xc_default_sw_version" {
  type    = bool
  default = true
}

variable "f5xc_volterra_software_version" {
  type    = string
  default = null
}

variable "csp_provider" {
  type = string
  validation {
    condition     = contains(["aws", "gcp", "azure", "vmware", "kvm"], var.csp_provider)
    error_message = format("Valid values for csp_provider: aws, gcp, azure, vmware, kvm")
  }
}
