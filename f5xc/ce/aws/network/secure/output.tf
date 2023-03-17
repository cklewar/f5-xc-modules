output "ce" {
  value = {
    eip    = aws_eip.secure_ce_eip
    subnet = aws_subnet.secure_ce
    nat_gw = aws_nat_gateway.secure_ce
  }
}