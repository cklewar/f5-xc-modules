resource "aws_instance" "instance" {
  ami                  = var.aws_instance_image
  instance_type        = var.aws_instance_type
  user_data            = var.f5xc_instance_config
  monitoring           = var.aws_instance_monitoring
  key_name             = var.ssh_public_key_name
  iam_instance_profile = var.aws_iam_instance_profile_id
  tags                 = local.common_tags

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
    delete = var.aws_instance_delete_timeout
  }
}

resource "volterra_registration_approval" "nodes" {
  depends_on   = [aws_instance.instance]
  cluster_name = var.f5xc_cluster_name
  cluster_size = var.f5xc_cluster_size
  hostname     = regex("[0-9A-Za-z_-]+", aws_instance.instance.private_dns)
  wait_time    = var.f5xc_registration_wait_time
  retry        = var.f5xc_registration_retry
}

resource "volterra_site_state" "decommission_when_delete" {
  depends_on = [volterra_registration_approval.nodes]
  name       = var.f5xc_node_name
  when       = "delete"
  state      = "DECOMMISSIONING"
  wait_time  = var.f5xc_registration_wait_time
  retry      = var.f5xc_registration_retry
}