output "ce" {
  value = {
    rt     = aws_route_table.secure_ce
    eip    = aws_eip.secure_ce
    subnet = aws_subnet.secure_ce
    nat_gw = aws_nat_gateway.secure_ce
  }
}