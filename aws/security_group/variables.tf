variable "aws_security_group_name" {
  type = string
}

variable "description" {
  type    = string
  default = ""
}

variable "aws_vpc_id" {
  type = string
}

variable "custom_tags" {
  description = "Custom tags to set on resources"
  type        = map(string)
  default     = {}
}

variable "security_group_rules_egress" {
  type = list(object({
    from_port   = optional(string)
    to_port     = optional(string)
    ip_protocol = string
    cidr_blocks = list(string)
  }))
}

variable "security_group_rules_ingress" {
  type = list(object({
    from_port   = optional(string)
    to_port     = optional(string)
    ip_protocol = string
    cidr_blocks = list(string)
  }))
}