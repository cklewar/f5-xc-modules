output "aws_ec2_instance_public_dns" {
  value = aws_instance.instance.public_dns
}

output "aws_ec2_instance_public_ip" {
  value = aws_eip.eip.public_ip
}