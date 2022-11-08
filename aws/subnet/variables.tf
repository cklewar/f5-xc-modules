variable "aws_vpc_id" {
  type = string
}

variable "aws_vpc_subnets" {
  type = list(object({
    map_public_ip_on_launch = bool
    cidr_block              = string
    availability_zone       = string
    owner                   = string
    custom_tags             = map(string)
  }))
}