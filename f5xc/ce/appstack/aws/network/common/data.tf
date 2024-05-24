data "aws_vpc" "vpc" {
  count = var.aws_existing_vpc_id != "" ? 1 : 0
  id    = var.aws_existing_vpc_id
}