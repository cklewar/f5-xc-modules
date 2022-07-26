resource "aws_network_interface" "compute_nic_private" {
  count             = var.machine_count
  subnet_id         = var.subnet_private_id
  security_groups   = [var.security_group_private_id]
  source_dest_check = false
  tags              = local.common_tags
}

resource "aws_network_interface" "compute_nic_inside" {
  count             = var.machine_count
  subnet_id         = var.subnet_inside_id
  security_groups   = [var.security_group_private_id]
  source_dest_check = false
  tags              = local.common_tags
}

resource "null_resource" "delay_eip_creation" {
  provisioner "local-exec" {
    command = "sleep 1"
  }

  triggers = {
    "before" = aws_instance.volterra_ce[0].id
  }
}

resource "aws_eip" "compute_public_ip" {
  count             = var.machine_count
  vpc               = true
  network_interface = element(aws_network_interface.compute_nic_private.*.id, count.index)
  depends_on        = [null_resource.delay_eip_creation]
  tags              = local.common_tags
}

resource "aws_instance" "volterra_ce" {
  count                = var.machine_count
  ami                  = var.machine_image
  instance_type        = var.machine_type
  user_data_base64     = base64encode(var.machine_config)
  monitoring           = "false"
  key_name             = var.key_name
  iam_instance_profile = var.iam_instance_profile_name

  tags = merge(
    local.common_tags,
    {
      "Name" = element(var.machine_names, count.index)
    },
  )

  root_block_device {
    volume_size = var.machine_disk_size
  }

  network_interface {
    network_interface_id = element(aws_network_interface.compute_nic_private.*.id, count.index)
    device_index         = "0"
  }

  network_interface {
    network_interface_id = element(aws_network_interface.compute_nic_inside.*.id, count.index)
    device_index         = "1"
  }

  timeouts {
    create = "60m"
    delete = "60m"
  }
}

resource "aws_lb_target_group_attachment" "volterra_ce_attachment" {
  count            = var.machine_count
  target_group_arn = var.target_group_arn
  target_id        = element(aws_instance.volterra_ce.*.id, count.index)
  port             = 6443
}

locals {
  machine_hostnames = [for dns in aws_instance.volterra_ce.*.private_dns : element(split(".", dns), 0)]
}

resource "volterra_registration_approval" "master_nodes" {
  count        = (var.enable_auto_registration == true) && (var.machine_count > 0) ? var.machine_count : 0
  cluster_name = var.deployment
  cluster_size = var.machine_count
  hostname     = element(local.machine_hostnames, count.index)
  wait_time    = 60
  retry        = 90
  depends_on   = [aws_instance.volterra_ce]
}

resource "volterra_site_state" "decommission_when_delete" {
  count      = (var.enable_auto_registration == true) && (var.machine_count > 0) ? 1 : 0
  name       = var.deployment
  when       = "delete"
  state      = "DECOMMISSIONING"
  wait_time  = 60
  retry      = 5
  depends_on = [volterra_registration_approval.master_nodes]
}