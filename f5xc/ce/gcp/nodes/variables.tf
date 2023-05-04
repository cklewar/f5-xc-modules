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

variable "allow_stopping_for_update" {
  type = bool
}

variable "instance_tags" {
  type = list(string)
}

variable "ssh_public_key" {
  type = string
}

variable "ssh_username" {
  type = string
}

variable "gcp_service_account_email" {
  type = string
}

variable "gcp_service_account_scopes" {
  type = list(string)
}

variable "access_config_nat_ip" {
  type = string
}

variable "has_public_ip" {
  type = bool
}

variable "is_sensitive" {
  type = bool
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

variable "f5xc_cluster_name" {
  type = string
}