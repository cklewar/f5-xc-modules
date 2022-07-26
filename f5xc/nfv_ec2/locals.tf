output "test123" {
  value = var.aws_ec2_instance_data
}

locals {
  source           = format("%s/_out/%s", path.module, var.aws_ec2_instance_userdata_file)
  destination      = format("/tmp/%s", var.aws_ec2_instance_userdata_file)
  userdata_content = templatefile(format("%s/templates/%s", path.module, var.aws_ec2_instance_userdata_template), var.aws_ec2_instance_data.userdata)
}

