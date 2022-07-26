variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "session_token" {
  type    = string
  default = ""
}

variable "region" {
  type = string
}

variable "deployment" {
  type = string
}

variable "dns_zone_name" {
  type    = string
  default = ""
}

variable "dns_zone_suffix" {
  type    = string
  default = "int.ves.io"
}

variable "service_port" {
  type    = string
  default = "6443"
}

variable "ver_rest_port" {
  type    = string
  default = "8005"
}

variable "ver_grpc_port" {
  type    = string
  default = "8505"
}

variable "fabric_address_pool" {
  type = string
}

variable "fabric_subnet_private" {
  type = string
}

variable "fabric_subnet_inside" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "ce_inside_intf_id" {
  type = string
}

variable "iam_owner" {
  type    = string
  default = "default"
}