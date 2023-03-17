resource "aws_eip" "secure_ce_eip" {
  vpc = true
}

resource "aws_nat_gateway" "secure_ce_nat_gateway" {
  tags          = var.common_tags
  subnet_id     = var.aws_subnet_id
  allocation_id = aws_eip.secure_ce_eip.id
}

resource "aws_route_table" "secure_ce_instance" {
  tags   = var.common_tags
  vpc_id = var.aws_vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.secure_ce_nat_gateway.id
  }
}

resource "aws_route_table_association" "secure_ce_instance" {
  subnet_id      = var.aws_subnet_id
  route_table_id = aws_route_table.secure_ce_instance.id
}