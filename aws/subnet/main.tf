resource "aws_subnet" "subnet" {
  for_each                = {for k, v in var.aws_vpc_subnets : k => v}
  tags                    = merge({ Name = each.value.name, Owner = each.value.owner }, each.value.custom_tags)
  vpc_id                  = var.aws_vpc_id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_route_table" "rt" {
  for_each = {for k, v in var.aws_vpc_subnets : k => v}
  tags     = merge({ Name = each.value.name, Owner = each.value.owner }, each.value.custom_tags)
  vpc_id   = var.aws_vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = each.value.igw_id
  }
}