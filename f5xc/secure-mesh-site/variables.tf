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
    name = string
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

variable "f5xc_site_type_certified_hw" {
  type    = map(string)
  default = {
    ingress_gateway        = "generic-single-nic-voltmesh"
    ingress_egress_gateway = "generic-regular-nic-voltmesh"
  }
}

variable "f5xc_ce_gateway_type" {
  type = string
  validation {
    condition     = contains(["ingress_egress_gateway", "ingress_gateway",], var.f5xc_ce_gateway_type)
    error_message = format("Valid values for gateway_type: ingress_egress_gateway, ingress_gateway")
  }
}