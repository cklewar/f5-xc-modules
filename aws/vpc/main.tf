resource "aws_vpc" "vpc" {
  cidr_block           = var.aws_vpc_cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_classiclink   = var.enable_classiclink
  instance_tenancy     = var.instance_tenancy

  /*dynamic "tags" {
    for_each = var.custom_tags
    content {
      key   = tags.key
      value = tags.value
    }
  }*/
}
