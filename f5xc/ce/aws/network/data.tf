data "aws_availability_zones" "available_az" {}

data "aws_vpc" "vpc" {
  id   = var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : aws_vpc.vpc.id
  tags = local.common_tags
}