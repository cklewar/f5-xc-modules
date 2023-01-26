variable "region" {
  default = "us-east-2"
}

variable "deployment" {
  default = "k8s-lb-net-tst"
}

variable "dns_zone_name" {
  default = ""
}

variable "dns_zone_suffix" {
  default = "int.ves.io"
}

variable "service_port" {
  default = "6443"
}

variable "ver_rest_port" {
  default = "8005"
}

variable "ver_grpc_port" {
  default = "8505"
}

variable "fabric_address_pool" {
  default = "192.168.32.0/22"
}

variable "fabric_subnet_private" {
  default = "192.168.32.0/25"
}

variable "fabric_subnet_inside" {
  default = "192.168.32.128/25"
}

variable "vpc_id" {
}

variable "ce_inside_intf_id" {
}

variable "iam_owner" {
  default = "default"
}