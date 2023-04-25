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

variable "f5xc_nfv_domain_suffix" {
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
  default = true
}

variable "f5xc_https_mgmt_advertise_on_public_default_vip" {
  type    = bool
  default = false
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
    http_port                    = optional(bool)
    https_port                   = optional(bool)
    no_udp_ports                 = optional(bool)
    no_tcp_ports                 = optional(bool)
    automatic_vip                = optional(bool)
    configured_vip               = optional(bool)
    default_tcp_ports            = optional(bool)
    advertise_on_slo_ip          = optional(bool)
    disable_advertise_on_slo_ip  = optional(bool)
    advertise_on_slo_ip_external = optional(bool)
  })
  default = {
    no_udp_ports                 = true
    default_tcp_ports            = true
    automatic_vip                = true
    advertise_on_slo_ip          = false
    disable_advertise_on_slo_ip  = true
    advertise_on_slo_ip_external = true
  }
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

variable "f5xc_https_mgmt_advertise_on_sli_vip" {
  type    = bool
  default = false
}

variable "f5xc_https_mgmt_advertise_on_slo_internet_vip" {
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

variable "f5xc_enabled_ssh_access_advertise_on_public_default_vip" {
  type    = bool
  default = false
}

variable "f5xc_enabled_ssh_access_ssh_ports" {
  type    = list(number)
  default = []
}

variable "f5xc_enabled_ssh_access_advertise_on_public" {
  type = object({
    name      = string
    tenant    = string
    namespace = string
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

variable "f5xc_aws_nfv_nodes" {
  type = map(object({
    aws_az_name          = string
    tunnel_prefix        = optional(string)
    automatic_prefix     = optional(bool)
    reserved_mgmt_subnet = bool
    mgmt_subnet          = optional(object({
      existing_subnet_id = string
      subnet_param       = object({
        ipv4 = string
        ipv6 = optional(string)
      })
    }))
  }))
  validation {
    condition     = length(var.f5xc_aws_nfv_nodes) == 1 || length(var.f5xc_aws_nfv_nodes) == 2
    error_message = "f5xc_aws_nfv_nodes supports one or two nodes only"
  }
}

variable "f5xc_pan_ami_bundle1" {
  type    = bool
  default = true
}

variable "f5xc_pan_ami_bundle2" {
  type    = bool
  default = false
}

variable "f5xc_pan_version" {
  type    = string
  default = "11.0.0"
}

variable "f5xc_pan_disable_panorama" {
  type    = bool
  default = true
}

variable "f5xc_pan_panorama_server" {
  type    = string
  default = ""
}

variable "f5xc_pan_panorama_device_group_name" {
  type    = string
  default = ""
}

variable "f5xc_pan_panorama_template_stack_name" {
  type    = string
  default = ""
}

variable "f5xc_pan_panorama_server_authorization_key" {
  type    = string
  default = ""
}

variable "f5xc_pan_auto_setup_autogenerated_ssh_keys" {
  type    = bool
  default = true
}

variable "f5xc_pan_auto_setup" {
  type    = bool
  default = false
}

variable "f5xc_enable_nfv_wait_for_online" {
  type    = bool
  default = false
}

variable "f5xc_pan_instance_type" {
  type    = string
  default = "PALO_ALTO_FW_AWS_INSTANCE_TYPE_M5_2XLARGE"
}

variable "is_sensitive" {
  type    = bool
  default = false
}