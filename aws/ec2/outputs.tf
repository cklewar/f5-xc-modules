output "aws_ec2_instance" {
  value = {
    "script_file"        = var.aws_ec2_instance_script_file
    "script_source"      = "${var.template_output_dir_path}/${var.aws_ec2_instance_script_file}"
    "script_destination" = format("/tmp/%s", var.aws_ec2_instance_script_file)
    "public_dns"         = aws_instance.instance.public_dns
    "public_ip"          = aws_eip.eip.public_ip
    "private_ip"         = aws_network_interface.private.private_ip
  }
}