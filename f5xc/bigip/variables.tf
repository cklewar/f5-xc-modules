variable "bigip_address" {
  type = string
}

variable "bigip_admin_username" {
  type = string
}

variable "bigip_admin_password" {
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

variable "bigip_token_based_auth_uri" {
  type    = string
  default = "mgmt/shared/authn/login"
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

variable "aws_ec2_vcs_instance_schema" {
  type    = string
  default = "http"
}

variable "aws_ec2_vcs_instance_public_ip" {
  type = string
}

variable "aws_ec2_vcs_instance_private_ip" {
  type = string
}

variable "aws_ec2_vcs_instance_port" {
  type    = string
  default = "3000"
}

variable "aws_ec2_vcs_instance_uri" {
  type    = string
  default = "gitea/awaf/raw/branch/master"
}

variable "owner_tag" {
  type = string
}

variable "ssh_private_key" {
  type = string
}