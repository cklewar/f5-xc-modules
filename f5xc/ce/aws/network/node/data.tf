data "aws_subnet" "slo" {
  count = var.aws_existing_slo_subnet_id != "" ? 1 : 0
  id    = var.aws_existing_slo_subnet_id
}

data "aws_subnet" "sli" {
  count = var.is_multi_nic && var.aws_existing_sli_subnet_id != "" ? 1 : 0
  id    = var.aws_existing_sli_subnet_id
}