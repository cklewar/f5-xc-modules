variable "nfv_domain_suffix" {
  type = string
}

variable "nfv_node_name" {
  type = string
}

variable "bigip_admin_username" {
  type = string
}

variable "bigip_admin_password" {
  type = string
}

variable "bigip_as3_rpm" {
  type = string
}

variable "bigip_as3_rpm_url" {
  type = string
}

variable "bigip_ltm_pool_name" {
  type = string
}

variable "bigip_ltm_pool_node_name" {
  type = string
}

variable "bigip_ltm_monitor_name" {
  type = string
}

variable "bigip_ltm_virtual_server_name" {
  type = string
}

variable "bigip_ltm_virtual_server_ip" {
  type = string
}

variable "bigip_ltm_pool_node_ip" {
  type = string
}

variable "bigip_as3_awaf_policy_template" {
  type = string
}

variable "bigip_as3_awaf_policy" {
  type = string
}

variable "bigip_interface_internal_ip" {
  type = string
}

variable "bigip_tenant" {
  type = string
}

variable "aws_ec2_vcs_instance_protocol" {
  type    = string
  default = "http"
}

variable "aws_ec2_vcs_instance_ip" {
  type = string
}

variable "aws_ec2_vcs_instance_port" {
  type = string
}

variable "aws_ec2_vcs_instance_uri" {
  type = string
}

variable "owner_tag" {
  type = string
}