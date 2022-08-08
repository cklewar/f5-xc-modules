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
  default = ""
}

variable "f5xc_origin_pool_loadbalancer_algorithm" {
  type    = string
  default = ""
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