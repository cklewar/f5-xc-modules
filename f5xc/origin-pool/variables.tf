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
  type    = map(string)
  default = {}
}

variable "f5xc_origin_pool_port" {
  type = string
}

variable "f5xc_origin_pool_no_tls" {
  type    = bool
  default = true
}

variable "f5xc_origin_pool_no_mtls" {
  type    = bool
  default = false
}

variable "f5xc_origin_pool_mtls_certificate_url" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_mtls_private_key_clear_secret_url" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_tls_skip_server_verification" {
  type    = bool
  default = true
}

variable "f5xc_origin_pool_tls_sni" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_tls_use_host_header_as_sni" {
  type    = bool
  default = false
}

variable "f5xc_origin_pool_tls_default_security" {
  type    = bool
  default = true
}

variable "f5xc_origin_pool_tls_low_security" {
  type    = bool
  default = false
}

variable "f5xc_origin_pool_tls_medium_security" {
  type    = bool
  default = false
}

variable "f5xc_origin_pool_tls_volterra_trusted_ca" {
  type    = bool
  default = false
}

variable "f5xc_origin_pool_tls_disable_sni" {
  type    = bool
  default = true
}

variable "f5xc_origin_pool_mtls_certificate_description" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_mtls_custom_hash_algorithms" {
  type    = list(string)
  default = []
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

variable "f5xc_origin_pool_vn_private_dns_name" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_private_ip" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_k8s_service_name" {
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

variable "f5xc_origin_pool_private_ip_site_locator" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_private_ip_site_locator_site_name" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_private_ip_inside_network" {
  type    = bool
  default = true
}

variable "f5xc_origin_pool_private_ip_outside_network" {
  type    = bool
  default = false
}

variable "f5xc_origin_pool_private_name_site_locator" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_private_name_site_locator_site_name" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_private_name_inside_network" {
  type    = bool
  default = true
}

variable "f5xc_origin_pool_private_name_outside_network" {
  type    = bool
  default = false
}

variable "f5xc_origin_pool_k8s_service_site_locator_site_name" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_k8s_service_inside_network" {
  type    = bool
  default = true
}

variable "f5xc_origin_pool_k8s_service_outside_network" {
  type    = bool
  default = false
}

variable "f5xc_origin_pool_consul_service_name" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_consul_service_inside_network" {
  type    = bool
  default = true
}

variable "f5xc_origin_pool_consul_service_outside_network" {
  type    = bool
  default = false
}

variable "f5xc_origin_pool_consul_service_site_locator_site_name" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_vn_private_ip_virtual_network_name" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_vn_private_name_site_locator_site_name" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_k8s_service_site_locator_virtual_site_name" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_consul_service_site_locator_virtual_site_name" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_private_name_site_locator_virtual_site_name" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_private_ip_site_locator_virtual_site_name" {
  type    = string
  default = ""
}

variable "f5xc_origin_pool_healthcheck_name" {
  type    = string
  default = ""
}