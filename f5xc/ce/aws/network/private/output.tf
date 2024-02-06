output "ce" {
  value = {
    rt     = aws_route_table.private_ce
    eip    = aws_eip.private_ce
    subnet = aws_subnet.private_ce
    nat_gw = aws_nat_gateway.private_ce
  }
}