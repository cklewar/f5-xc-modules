variable "nfv_domain_suffix" {
  type = string
}

variable "nfv_node_name" {
  type = string
}

variable "bigip_address" {
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

variable "provisioner_connection_type" {
  type    = string
  default = "ssh"
}

variable "provisioner_connection_user" {
  type    = string
  default = "ubuntu"
}

variable "provisioner_connection_timeout" {
  type    = string
  default = "1m"
}

variable "aws_ec2_vcs_instance_protocol" {
  type    = string
  default = "http"
}

variable "aws_ec2_vcs_instance_address" {
  type = string
}

variable "aws_ec2_ssh_address" {
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

variable "private_ssh_key" {
  type = string
}