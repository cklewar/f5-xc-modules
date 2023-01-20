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

variable "sli_subnetwork" {
  type = string
}

variable "slo_subnetwork" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "ssh_username" {
  type = string
}

variable "f5xc_ce_user_data" {
  type = string
}

variable "f5xc_cluster_size" {
  type = number
}

variable "f5xc_registration_wait_time" {
  type = number
}

variable "f5xc_registration_retry" {
  type = number
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

variable "use_public_ip" {
  type        = bool
  default     = true
  description = "Whether to include the access_config{} into the instance, adding a public Internet IP address, otherwise use NAT."
}
