resource "aws_eip" "private_ce" {
  count = 1
}

resource "aws_subnet" "private_ce" {
  tags              = merge({ "Name" : format("%s-secure-ce", var.f5xc_node_name) }, var.common_tags)
  vpc_id            = var.aws_vpc_id
  cidr_block        = var.aws_vpc_nat_gw_subnet
  availability_zone = var.aws_vpc_az
}

resource "aws_nat_gateway" "private_ce" {
  tags          = merge({ "Name" : format("%s-secure-ce-nat-gw", var.f5xc_node_name) }, var.common_tags)
  subnet_id     = aws_subnet.private_ce.id
  allocation_id = aws_eip.private_ce[0].id
}

resource "aws_route_table" "private_ce" {
  tags   = merge({ "Name" : format("secure-ce-%s-rt", var.f5xc_node_name) }, var.common_tags)
  vpc_id = var.aws_vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.private_ce.id
  }
}

resource "aws_route_table_association" "subnet_private_ce_2_slo_subnet_rt" {
  subnet_id      = aws_subnet.private_ce.id
  route_table_id = var.slo_subnet_rt_id
}

resource "aws_route_table_association" "subnet_slo_2_private_ce_rt" {
  subnet_id      = var.slo_subnet_id
  route_table_id = aws_route_table.private_ce.id
}