resource "aws_subnet" "subnet" {
  for_each                = {for k, v in var.aws_vpc_subnets :  k => v}
  vpc_id                  = var.aws_vpc_id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  availability_zone       = each.value.availability_zone
  tags                    = merge({ Name = each.value.name,  Owner = each.value.owner}, each.value.custom_tags)
  lifecycle {
    ignore_changes = [tags]
  }
}