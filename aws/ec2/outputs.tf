output "aws_ec2_instance" {
  value = {
    "script_file"        = var.aws_ec2_instance_script_file
    "script_source"      = abspath(format("../modules/ec2/_out/%s", format("%s.sh", var.aws_ec2_instance_script_file)))
    "script_destination" = format("/tmp/%s", format("%s.sh", var.aws_ec2_instance_script_file))
    "userdata_source"    = abspath(format("../modules/ec2/userdata/%s", var.aws_ec2_instance_script_file))
    "public_dns"         = aws_instance.instance.public_dns
    "public_ip"          = aws_eip.eip.public_ip
    "private_ip"         = aws_network_interface.private.private_ip
  }
}