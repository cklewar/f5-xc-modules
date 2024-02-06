output "ce" {
  value = {
    id          = aws_instance.instance.id
    ami         = aws_instance.instance.ami
    name        = aws_instance.instance.tags["Name"]
    tags        = aws_instance.instance.tags
    public_ip   = aws_instance.instance.public_ip
    private_ip  = aws_instance.instance.private_ip
    private_dns = aws_instance.instance.private_dns
  }
}