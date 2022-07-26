locals {
  userdata_content = templatefile(var.aws_ec2_instance_userdata_template, var.aws_ec2_instance_data.userdata)
}