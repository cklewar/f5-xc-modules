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
  type    = string
  default = ""
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_origin_pool_name" {
  type = string
}

variable "f5xc_origin_pool_endpoint_selection" {
  type    = string
  default = "LOCAL_PREFERRED"

  validation {
    condition     = contains(["LOCAL_PREFERRED", "LOCAL_ONLY", "DISTRIBUTED"], var.f5xc_origin_pool_endpoint_selection)
    error_message = format("Valid values for f5xc_origin_pool_endpoint_selection: LOCAL_PREFERRED, LOCAL_ONLY, DISTRIBUTED")
  }
}

variable "f5xc_origin_pool_loadbalancer_algorithm" {
  type    = string
  default = "ROUND_ROBIN"

  validation {
    condition = contains([
      "ROUND_ROBIN", "LEAST_REQUEST", "RING_HASH", "LB_OVERRIDE", "RANDOM"
    ], var.f5xc_origin_pool_loadbalancer_algorithm)
    error_message = format("Valid values for f5xc_origin_pool_loadbalancer_algorithm: ROUND_ROBIN, LEAST_REQUEST, RING_HASH, LB_OVERRIDE, RANDOM")
  }

}

variable "f5xc_origin_pool_labels" {
  type = map(string)
}

variable "f5xc_origin_pool_port" {
  type = string
}

variable "f5xc_origin_pool_no_tls" {
  type    = bool
  default = true
}

variable "f5xc_origin_pool_use_tls" {
  type    = bool
  default = false
}

variable "f5xc_origin_pool_public_ip" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_public_name" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_private_name" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_vn_private_name" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_private_ip" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_k8s_service" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_consul_service" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_vn_private_ip" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_custom_endpoint_object_name" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_same_as_endpoint_port" {
  type    = bool
  default = true
}

variable "f5xc_origin_pool_health_check_port" {
  type    = string
  default = ""
}