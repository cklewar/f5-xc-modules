variable "ssh_private_key" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_az_name" {
  type = string
}

variable "aws_ec2_instance_script" {
  default = null
}

variable "aws_ec2_instance_script_template" {
  type    = string
  default = ""
}

variable "aws_ec2_instance_cloud_init_template_data" {
  type = map(string)
  default = {}
}

variable "aws_ec2_instance_cloud_init_template" {
  type    = string
  default = ""
}

variable "template_output_dir_path" {
  type = string
}

variable "template_input_dir_path" {
  type = string
}

variable "aws_ec2_instance_script_file" {
  type    = string
  default = ""
}

variable "aws_ec2_instance_name" {
  type = string
}

variable "aws_ec2_instance_type" {
  type = string
}

variable "aws_ec2_instance_custom_data_dirs" {
  type = list(object({
    name        = string
    source      = string
    destination = string
  }))
}

variable "amis" {
  type        = map(string)
  description = "The instance will use amis for ubuntu 22.04 LTS"
  default = {
    "us-east-1"    = "ami-012485deee5681dc0"
    "us-east-2"    = "ami-0df0b6b7f8f5ea0d0"
    "us-west-1"    = "ami-0344e2943d3053eda"
    "us-west-2"    = "ami-0526a31610d9ba25a"
    "eu-central-1" = "ami-0c027353d00750a02"
    "eu-west-1"    = "ami-003c6328b40ce2af6"
    "eu-west-2"    = "ami-0d05d6fe284781e13"
    "eu-west-3"    = "ami-061fc0c4ca50c3135"
    "eu-north-1"   = "ami-0c0a1c5b612d238ae"
  }
}

variable "aws_ec2_network_interfaces_ref" {
  type = list(object({
    device_index         = number
    network_interface_id = string
  }))
  default = []
}

variable "aws_ec2_network_interfaces" {
  type = list(object({
    create_eip      = bool
    private_ips     = optional(list(string), [])
    security_groups = list(string)
    subnet_id       = string
    custom_tags     = optional(map(string))
  }))
  default = []
}

variable "aws_ec2_user_data_replace_on_change" {
  type    = bool
  default = true
}

variable "owner" {
  type = string
}

variable "custom_tags" {
  description = "Custom tags to set on resources"
  type        = map(string)
  default = {}
}

variable "provisioner_connection_type" {
  type    = string
  default = "ssh"
}

variable "provisioner_connection_user" {
  type    = string
  default = "ubuntu"
}