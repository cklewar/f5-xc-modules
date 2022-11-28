variable "f5xc_namespace" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_tcp_lb_name" {
  type = string
}

variable "f5xc_tcp_lb_advertise_on_public_default_vip" {
  type    = bool
  default = true
}

variable "f5xc_tcp_lb_do_not_advertise" {
  type    = bool
  default = false
}

variable "f5xc_tcp_lb_advertise_on_public" {
  type    = bool
  default = false
}

variable "f5xc_tcp_lb_advertise_custom" {
  type    = bool
  default = false
}

variable "f5xc_tcp_lb_disable_api_definition" {
  type    = bool
  default = true
}

variable "f5xc_tcp_lb_no_challenge" {
  type    = bool
  default = true
}

variable "f5xc_tcp_lb_domains" {
  type = list(string)
}

variable "f5xc_tcp_lb_round_robin" {
  type    = bool
  default = true
}

variable "f5xc_tcp_lb_least_active" {
  type    = bool
  default = false
}

variable "f5xc_tcp_lb_random" {
  type    = bool
  default = false
}

variable "f5xc_tcp_lb_source_ip_stickiness" {
  type    = bool
  default = false
}

variable "f5xc_tcp_lb_cookie_stickiness" {
  type    = bool
  default = false
}

variable "f5xc_tcp_lb_ring_hash" {
  type    = bool
  default = false
}

variable "f5xc_tcp_lb_disable_rate_limit" {
  type    = bool
  default = true
}

variable "f5xc_tcp_lb_user_id_client_ip" {
  type    = bool
  default = true
}

variable "f5xc_tcp_lb_disable_waf" {
  type    = bool
  default = true
}

variable "f5xc_tcp_lb_port" {
  type = string
}

variable "f5xc_tcp_lb_dns_volterra_managed" {
  type    = bool
  default = true
}