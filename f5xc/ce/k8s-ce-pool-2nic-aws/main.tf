resource "aws_launch_configuration" "volterra_ce_config" {
  associate_public_ip_address = true
  image_id                    = var.machine_image
  instance_type               = var.machine_type
  name_prefix                 = "pool-"
  security_groups             = [var.security_group_private_id]
  user_data_base64            = base64encode(var.machine_config)
  key_name                    = var.key_name
  iam_instance_profile        = "${var.deployment}-profile"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "volterra_ce" {
  desired_capacity     = var.machine_count
  launch_configuration = aws_launch_configuration.volterra_ce_config.id
  name                 = "volt-ce-${aws_launch_configuration.volterra_ce_config.name}"
  max_size             = 10
  min_size             = 0
  vpc_zone_identifier  = [var.subnet_private_id, var.subnet_inside_id]

  dynamic "tag" {
    for_each = local.aws_autoscale_group_tags

    content {
      key                 = "1"
      value               = "2"
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

