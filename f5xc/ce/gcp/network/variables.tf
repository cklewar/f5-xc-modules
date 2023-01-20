variable "gcp_region" {
  type = string
}

variable "fabric_subnet_outside" {
  type = string
}

variable "fabric_subnet_inside" {
  type = string
}

variable "network_name" {
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

variable "f5xc_sli_ingress_target_tags" {
  type = list(string)
}

variable "f5xc_sli_egress_target_tags" {
  type = list(string)
}

variable "f5xc_slo_ingress_target_tags" {
  type = list(string)
}

variable "f5xc_slo_egress_target_tags" {
  type = list(string)
}

variable "f5xc_sli_ingress_source_ranges" {
  type = list(string)
}

variable "f5xc_sli_egress_source_ranges" {
  type = list(string)
}

variable "f5xc_slo_ingress_source_ranges" {
  type = list(string)
}

variable "f5xc_slo_egress_source_ranges" {
  type = list(string)
}