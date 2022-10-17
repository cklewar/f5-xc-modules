variable "aws_security_group_name" {
  type = string
}

variable "aws_vpc_id" {
  type = string
}

variable "aws_security_group_rule_egress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = any
    cidr_blocks = list(string)
  }))
}

variable "aws_security_group_rule_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = any
    cidr_blocks = list(string)
  }))
}

variable "aws_interface_security_groups" {
  type = list(string)
}

variable "aws_interface_subnet_id" {
  type = string
}

variable "aws_interface_private_ips" {
  type = list(string)
}

variable "aws_interface_create_eip" {
  type = bool
}

variable "custom_tags" {
  description = "Custom tags to set on resources"
  type        = map(string)
  default     = {}
}

