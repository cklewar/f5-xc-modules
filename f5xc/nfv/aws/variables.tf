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

variable "ssh_public_key" {
  type = string
}

variable "ssh_private_key" {
  type    = string
  default = ""
}

variable "f5xc_aws_az_name" {
  type = string
}

variable "f5xc_nfv_domain_suffix" {
  type = string
}

variable "f5xc_nfv_node_name" {
  type = string
}

variable "f5xc_nfv_admin_username" {
  type = string
}

variable "f5xc_nfv_admin_password" {
  type = string
}

variable "f5xc_nfv_name" {
  type = string
}

variable "custom_tags" {
  description = "Custom tags to set on resources"
  type        = map(string)
  default     = {}
}

variable "f5xc_nfv_type_f5_big_ip_aws_service" {
  type    = string
  default = "f5_big_ip_aws_service"
}

variable "f5xc_nfv_type_palo_alto_fw_service" {
  type    = string
  default = "palo_alto_fw_service"
}

variable "f5xc_nfv_type" {
  type = string
}

variable "f5xc_https_mgmt_do_not_advertise" {
  type    = bool
  default = false
}

variable "f5xc_https_mgmt_advertise_on_public_default_vip" {
  type    = bool
  default = true
}

variable "f5xc_https_mgmt_default_https_port" {
  type    = bool
  default = true
}

variable "f5xc_big_ip_aws_service_market_place_image_AWAFPayG3Gbps" {
  type    = bool
  default = false
}

variable "f5xc_big_ip_aws_service_market_place_image_AWAFPayG200Mbps" {
  type    = bool
  default = true
}

variable "f5xc_aws_service_byol_image" {
  type = object({
    image   = string
    license = object({
      clear_secret_info = object({
        url = string
      })
    })
  })
  default = null
}

variable "f5xc_nfv_disable_https_management" {
  type    = bool
  default = false
}

variable "f5xc_nfv_disable_ssh_access" {
  type    = bool
  default = true
}

variable "f5xc_nfv_svc_get_uri" {
  type    = string
  default = "config/namespaces/%s/nfv_services/%s"
}

variable "f5xc_nfv_endpoint_service" {
  type = object({
    no_udp_ports                 = bool
    default_tcp_ports            = bool
    advertise_on_slo_ip          = bool
    disable_advertise_on_slo_ip  = bool
    advertise_on_slo_ip_external = bool
  })
  default = {
    no_udp_ports                 = true
    default_tcp_ports            = true
    advertise_on_slo_ip          = false
    disable_advertise_on_slo_ip  = true
    advertise_on_slo_ip_external = false
  }
}

variable "f5xc_nfv_service_node_tunnel_prefix" {
  type    = string
  default = ""
}

variable "f5xc_https_mgmt_disable_local" {
  type    = bool
  default = false
}

variable "f5xc_https_mgmt_advertise_on_internet" {
  type    = bool
  default = false
}

variable "f5xc_https_mgmt_advertise_on_internet_public_ip" {
  type    = string
  default = ""
}

variable "f5xc_https_mgmt_advertise_on_internet_default_vip" {
  type    = bool
  default = false
}

variable "f5xc_https_mgmt_advertise_on_slo_sli" {
  type    = bool
  default = false
}

variable "f5xc_https_mgmt_advertise_on_slo_sli_tls_certificates" {
  type = object({
    description            = string
    certificate_url        = string
    use_system_defaults    = bool
    custom_hash_algorithms = list(string)
  })
  default = null
}

variable "f5xc_https_mgmt_advertise_on_slo_sli_tls_config" {
  type = object({
    low_security     = bool
    medium_security  = bool
    default_security = bool
    custom_security  = optional(object({
      cipher_suites = string
      max_version   = string
      min_version   = string
    }))
  })
  default = null
}

variable "f5xc_nfv_aws_vpc_site_params" {
  type = object({
    name      = string
    namespace = string
    tenant    = string
  })
  default = null
}

variable "f5xc_nfv_aws_tgw_site_params" {
  type = object({
    name      = string
    namespace = string
    tenant    = string
  })
  default = null
}

variable "f5xc_nodes_reserved_mgmt_subnet" {
  type = object({
    existing_subnet_id = string
    subnet_param       = object({
      ipv4 = string
      ipv6 = optional(string)
    })
  })
  default = null
}

variable "is_sensitive" {
  type    = bool
  default = false
}