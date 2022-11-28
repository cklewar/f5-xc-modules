locals {
  script_content     = templatefile(format("%s/%s", var.template_input_dir_path, var.aws_ec2_instance_script_template), var.aws_ec2_instance_script.template_data)
  cloud_init_content = var.aws_ec2_instance_cloud_init_template != "" ? templatefile(format("%s/%s", var.template_input_dir_path, var.aws_ec2_instance_cloud_init_template), var.aws_ec2_instance_script.template_data) : null
}

