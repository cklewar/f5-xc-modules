resource "aws_eip" "secure_ce" {
  count = 1
}

resource "aws_subnet" "secure_ce" {
  tags              = merge({ "Name" : format("%s-secure-ce", var.f5xc_node_name) }, var.common_tags)
  vpc_id            = var.aws_vpc_id
  cidr_block        = var.aws_vpc_nat_gw_subnet
  availability_zone = var.aws_vpc_az
}

resource "aws_nat_gateway" "secure_ce" {
  tags          = merge({ "Name" : format("%s-secure-ce-nat-gw", var.f5xc_node_name) }, var.common_tags)
  subnet_id     = aws_subnet.secure_ce.id
  allocation_id = aws_eip.secure_ce[0].id
}

resource "aws_route_table" "secure_ce" {
  tags   = merge({ "Name" : format("secure-ce-%s-rt", var.f5xc_node_name) }, var.common_tags)
  vpc_id = var.aws_vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.secure_ce.id
  }
}

resource "aws_route_table_association" "subnet_secure_ce_2_slo_subnet_rt" {
  subnet_id      = aws_subnet.secure_ce.id
  route_table_id = var.slo_subnet_rt_id
}

resource "aws_route_table_association" "subnet_slo_2_secure_ce_rt" {
  subnet_id      = var.slo_subnet_id
  route_table_id = aws_route_table.secure_ce.id
}