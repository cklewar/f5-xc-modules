variable "f5xc_aws_region" {
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

variable "f5xc_namespace" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "f5xc_aws_az_name" {
  type = string
}

variable "f5xc_tgw_name" {
  type = string
}

variable "f5xc_nfv_svc_create_uri" {
  type    = string
  default = "config/namespaces/%s/nfv_services"
}

variable "f5xc_nfv_svc_delete_uri" {
  type    = string
  default = "config/namespaces/%s/nfv_services"
}

variable "f5xc_nfv_svc_get_uri" {
  type    = string
  default = "config/namespaces/%s/nfv_services/%s"
}

variable "f5xc_nfv_payload_template" {
  type    = string
  default = "payload.tftpl"
}

variable "f5xc_nfv_payload_file" {
  type    = string
  default = "payload.json"
}

variable "f5xc_nfv_domain_suffix" {
  type = string
}

variable "f5xc_nfv_node_name" {
  type = string
}

variable "f5xc_nfv_admin_username" {
  type = string
}

variable "f5xc_nfv_admin_password" {
  type = string
}

variable "f5xc_nfv_name" {
  type = string
}

variable "f5xc_nfv_description" {
  type = string
}

variable "custom_tags" {
  description = "Custom tags to set on resources"
  type        = map(string)
  default     = {}
}

variable "f5xc_nfv_labels" {
  type    = map(string)
  default = {}
}
