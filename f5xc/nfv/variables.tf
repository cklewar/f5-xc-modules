variable "aws_region" {
  type = string
}

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
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "public_ssh_key" {
  type = string
}

variable "aws_az_name" {
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
  type = string
  default = "payload.tftpl"
}

variable "f5xc_nfv_payload_file" {
  type = string
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

variable "f5xc_aws_tgw_site_get_uri" {
  type    = string
  default = "config/namespaces/%s/aws_tgw_sites/%s"
}

variable "aws_owner_tag" {
  type = string
}
