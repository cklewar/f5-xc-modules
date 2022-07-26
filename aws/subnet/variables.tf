variable "aws_vpc_id" {
  type = string
}

variable "custom_tags" {
  description = "Custom tags to set on resources"
  type        = map(string)
  default     = {}
}

variable "aws_vpc_subnets" {
  type = list(object({
    map_public_ip_on_launch = bool
    cidr_block              = string
    availability_zone       = string
    custom_tags             = map(string)
  }))
}