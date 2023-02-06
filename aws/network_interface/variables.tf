variable "aws_interface_security_groups" {
  type = list(string)
}

variable "aws_interface_subnet_id" {
  type = string
}

variable "aws_interface_private_ips" {
  type    = list(string)
  default = []
}

variable "aws_interface_create_eip" {
  type = bool
}

variable "aws_interface_source_dest_check" {
  type    = bool
  default = true
}

variable "custom_tags" {
  description = "Custom tags to set on resources"
  type        = map(string)
  default     = {}
}

