data "aws_vpc" "vpc" {
  id   = var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : aws_vpc.vpc[0].id
  tags = local.common_tags
}