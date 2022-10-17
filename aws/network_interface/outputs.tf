output "aws_network_interface" {
  value = {
    id               = aws_network_interface.interface.id
    subnet_id        = aws_network_interface.interface.subnet_id
    private_ip       = aws_network_interface.interface.private_ip
    private_ips      = aws_network_interface.interface.private_ips
    ipv4_prefixes    = aws_network_interface.interface.ipv4_prefixes
    interface_type   = aws_network_interface.interface.interface_type
    private_dns_name = aws_network_interface.interface.private_dns_name
  }
}