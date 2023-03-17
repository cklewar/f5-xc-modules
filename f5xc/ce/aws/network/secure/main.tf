resource "aws_subnet" "secure_ce" {
  vpc_id            = var.aws_vpc_id
  cidr_block        = var.aws_subnet
  availability_zone = var.aws_vpc_az
  tags              = var.common_tags
}

resource "aws_eip" "secure_ce_eip" {
  vpc = true
}

resource "aws_nat_gateway" "secure_ce" {
  tags          = var.common_tags
  subnet_id     = aws_subnet.secure_ce.id
  allocation_id = aws_eip.secure_ce_eip.id
}

resource "aws_route_table" "secure_ce" {
  tags   = var.common_tags
  vpc_id = var.aws_vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.secure_ce.id
  }
}

resource "aws_route_table_association" "secure_ce_instance" {
  subnet_id      = aws_subnet.secure_ce.id
  route_table_id = aws_route_table.secure_ce.id
}