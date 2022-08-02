resource "aws_subnet" subnet {
  for_each                = {for k, v in var.aws_vpc_subnets :  k => v}
  vpc_id                  = var.aws_vpc_id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  availability_zone       = each.value.availability_zone
  tags                    = each.value.custom_tags

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.aws_vpc_id
  tags   = var.custom_tags
}

resource "aws_route_table" "rt" {
  vpc_id = var.aws_vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = var.custom_tags
}

resource "aws_route_table_association" "subnet" {
  for_each       = {for idx, val in aws_subnet.subnet : idx => val}
  subnet_id      = each.value.id
  route_table_id = aws_route_table.rt.id
}