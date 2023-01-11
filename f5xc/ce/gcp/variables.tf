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

variable "instance_name" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "machine_image" {
  type = string
}

variable "machine_disk_size" {
  type = string
}

variable "public_name" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "ssh_username" {
  type    = string
  default = "centos"
}

variable "f5xc_cluster_size" {
  type    = number
  default = 1
}

variable "f5xc_registration_wait_time" {
  type    = number
  default = 60
}

variable "f5xc_registration_retry" {
  type    = number
  default = 20
}

variable "f5xc_ce_gateway_type" {
  type    = string
  default = "ingress_gateway"
  validation {
    condition     = contains(["ingress_egress_gateway", "ingress_gateway"], var.f5xc_ce_gateway_type)
    error_message = format("Valid values for gateway_type: ingress_egress_gateway, ingress_gateway")
  }
}

variable "f5xc_cluster_latitude" {
  type = string
}

variable "f5xc_cluster_longitude" {
  type = string
}

variable "f5xc_fleet_label" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_token_name" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

locals {
  cluster_labels = var.f5xc_fleet_label != "" ? { "ves.io/fleet" = var.f5xc_fleet_label } : {}
}