variable "aws_vpc_id" {
  type = string
}

variable "aws_vpc_subnets" {
  type = list(object({
    name                    = string
    owner                   = string
    cidr_block              = string
    custom_tags             = map(string)
    availability_zone       = string
    map_public_ip_on_launch = bool
  }))
}