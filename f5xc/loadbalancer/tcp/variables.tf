<<<<<<< HEAD
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

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_http_loadbalancer_name" {
  type = string
}

variable "f5xc_http_loadbalancer_advertise_on_public_default_vip" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_do_not_advertise" {
  type    = bool
  default = false
}

variable "f5xc_http_loadbalancer_advertise_on_public" {
  type    = bool
  default = false
}

variable "f5xc_http_loadbalancer_advertise_custom" {
  type    = bool
  default = false
}

variable "f5xc_http_loadbalancer_disable_api_definition" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_no_challenge" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_domains" {
  type = list(string)
}

variable "f5xc_http_loadbalancer_round_robin" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_least_active" {
  type    = bool
  default = false
}

variable "f5xc_http_loadbalancer_random" {
  type    = bool
  default = false
}

variable "f5xc_http_loadbalancer_source_ip_stickiness" {
  type    = bool
  default = false
}

variable "f5xc_http_loadbalancer_cookie_stickiness" {
  type    = bool
  default = false
}

variable "f5xc_http_loadbalancer_ring_hash" {
  type    = bool
  default = false
}

variable "f5xc_http_loadbalancer_disable_rate_limit" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_user_id_client_ip" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_disable_waf" {
  type    = bool
  default = true
}

variable "f5xc_http_loadbalancer_port" {
  type = string
}

variable "f5xc_http_loadbalancer_dns_volterra_managed" {
  type    = bool
  default = true
}
=======
>>>>>>> 368a486 (0.11.33)
