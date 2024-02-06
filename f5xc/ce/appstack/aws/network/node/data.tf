data "aws_subnet" "slo" {
  count = var.aws_existing_slo_subnet_id != null ? 1 : 0
  id    = var.aws_existing_slo_subnet_id
}