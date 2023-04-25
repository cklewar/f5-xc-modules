resource "aws_subnet" "k0s_subnet" {
  vpc_id = var.vpc_id

  cidr_block        = var.subnet_cidr
  availability_zone = format("%s%s", var.aws_region, var.aws_az)

  tags = {
    Name = "${var.site_name}"
    Creator = var.owner_tag
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.custom_vip_cidr
    network_interface_id = aws_instance.ce.primary_network_interface_id
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  tags = {
    Name = "${var.site_name}"
    Creator = var.owner_tag
  }
}

resource "aws_route_table_association" "k0s_route_table_association" {
  subnet_id      = aws_subnet.k0s_subnet.id
  route_table_id = aws_route_table.route_table.id
}
