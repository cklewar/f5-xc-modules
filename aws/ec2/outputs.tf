output "aws_ec2_instance_script_source" {
  value = abspath(format("../modules/ec2/_out/%s", format("%s.sh", var.aws_ec2_instance_script_file)))
}

output "aws_ec2_instance_script_destination" {
  value = format("/tmp/%s", format("%s.sh", var.aws_ec2_instance_script_file))
}

output "aws_ec2_instance_userdata_source" {
  value = abspath(format("../modules/ec2/userdata/%s", var.aws_ec2_instance_script_file))
}

output "aws_ec2_instance_public_dns" {
  value = aws_instance.instance.public_dns
}

output "aws_ec2_instance_public_ip" {
  value = aws_eip.eip.public_ip
}

output "aws_ec2_instance_private_ip" {
  value = aws_network_interface.private.private_ip
}
