resource "aws_instance" "instance" {
  ami                  = var.aws_instance_image # "ami-0a4218dd27123de5e"
  tags                 = local.common_tags
  key_name             = var.ssh_public_key_name
  monitoring           = var.aws_instance_monitoring
  instance_type        = var.aws_instance_type
  user_data_base64     = base64encode(var.f5xc_instance_config)
  iam_instance_profile = var.aws_iam_instance_profile_id

  root_block_device {
    volume_size = var.aws_instance_disk_size
  }

  network_interface {
    network_interface_id = var.aws_interface_slo_id
    device_index         = "0"
  }

  dynamic "network_interface" {
    for_each = var.is_multi_nic ? [1] : []
    content {
      network_interface_id = var.aws_interface_sli_id
      device_index         = "1"
    }
  }

  timeouts {
    create = var.aws_instance_create_timeout
    update = var.aws_instance_update_timeout
    delete = var.aws_instance_delete_timeout
  }

  lifecycle {
    ignore_changes = [
      tags, iam_instance_profile, root_block_device, network_interface,
      user_data_base64, ami
    ]
  }
}

resource "aws_ebs_volume" "ebs_volume_instance" {
  availability_zone = aws_instance.instance.availability_zone
  size              = var.aws_instance_disk_size
  type              = "gp2"
  tags              = merge(
    local.common_tags, {
      "Name" = "ebs_volume_${lookup(aws_instance.instance.tags, "Name")}"
    }
  )
}

resource "aws_volume_attachment" "ebs_attach" {
  volume_id   = aws_ebs_volume.ebs_volume_instance.id
  device_name = "/dev/sdf"
  instance_id = aws_instance.instance.id
}


resource "aws_lb_target_group_attachment" "volterra_ce_attachment" {
  count            = var.f5xc_cluster_size == 3 ? 1 : 0
  target_group_arn = var.aws_lb_target_group_arn
  target_id        = aws_instance.instance.id
  port             = 6443
}

resource "volterra_registration_approval" "nodes" {
  depends_on   = [aws_instance.instance]
  retry        = var.f5xc_registration_retry
  hostname     = regex("[0-9A-Za-z_-]+", aws_instance.instance.private_dns)
  latitude     = var.f5xc_cluster_latitude
  longitude    = var.f5xc_cluster_longitude
  wait_time    = var.f5xc_registration_wait_time
  tunnel_type  = lookup(var.f5xc_ce_to_re_tunnel_types, var.f5xc_ce_to_re_tunnel_type)
  cluster_name = var.f5xc_cluster_name
  cluster_size = var.f5xc_cluster_size
}

resource "volterra_site_state" "decommission_when_delete" {
  depends_on = [volterra_registration_approval.nodes]
  name       = var.f5xc_node_name
  when       = "delete"
  state      = "DECOMMISSIONING"
  wait_time  = var.f5xc_registration_wait_time
  retry      = var.f5xc_registration_retry
}