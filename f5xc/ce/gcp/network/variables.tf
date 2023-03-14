variable "gcp_region" {
  type = string
}

variable "subnet_outside" {
  type = string
}

variable "subnet_inside" {
  type = string
}

variable "project_name" {
  type = string
}

variable "auto_create_subnetworks" {
  type    = bool
  default = false
}

variable "f5xc_ce_gateway_type_ingress" {
  type    = string
  default = "ingress_gateway"
}

variable "f5xc_ce_gateway_type_ingress_egress" {
  type    = string
  default = "ingress_egress_gateway"
}

variable "f5xc_ce_gateway_type" {
  type = string
}

variable "f5xc_is_secure_cloud_ce" {
  type = bool
}