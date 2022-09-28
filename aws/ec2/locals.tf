locals {
  script_content = templatefile(format("%s/templates/%s", path.root, var.aws_ec2_instance_script_template), var.aws_ec2_instance_data.template_data)
}

