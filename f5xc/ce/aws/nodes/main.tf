resource "aws_network_interface" "slo" {
  subnet_id         = var.subnet_slo_id
  security_groups   = [var.security_group_private_id]
  source_dest_check = false
  tags              = local.common_tags
}

resource "aws_network_interface" "sli" {
  count             = var.subnet_sli_id != "" ? 1 : 0
  subnet_id         = var.subnet_sli_id
  security_groups   = [var.security_group_private_id]
  source_dest_check = false
  tags              = local.common_tags
}

resource "null_resource" "delay_eip_creation" {
  provisioner "local-exec" {
    command = "sleep 1"
  }

  triggers = {
    "before" = aws_instance.instance.id
  }
}

resource "aws_eip" "public_ip" {
  depends_on        = [null_resource.delay_eip_creation]
  vpc               = true
  tags              = local.common_tags
  network_interface = aws_network_interface.slo.*.id
}

resource "aws_instance" "instance" {
  ami                  = var.machine_image
  instance_type        = var.machine_type
  user_data_base64     = base64encode(var.machine_config)
  monitoring           = "false"
  key_name             = "${var.instance_name}-key"
  iam_instance_profile = "${var.instance_name}-profile"
  tags                 = merge(
    local.common_tags,
    {
      "Name" = var.instance_name
    }
  )

  root_block_device {
    volume_size = var.machine_disk_size
  }

  network_interface {
    network_interface_id = aws_network_interface.slo.*.id
    device_index         = "0"
  }

  dynamic "network_interface" {
    for_each = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? [1] : []
    content {
      network_interface_id = aws_network_interface.sli.*.id
      device_index         = "1"
    }
  }

  timeouts {
    create = var.instance_create_timeout
    delete = var.instance_delete_timeout
  }
}

resource "aws_lb_target_group_attachment" "volterra_ce_attachment" {
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.instance.*.id
  port             = 6443
}

resource "volterra_registration_approval" "nodes" {
  depends_on   = [aws_instance.instance]
  cluster_name = var.cluster_name
  cluster_size = var.cluster_size
  hostname     = var.instance_name
  wait_time    = var.f5xc_registration_wait_time
  retry        = var.f5xc_registration_retry
}

resource "volterra_site_state" "decommission_when_delete" {
  depends_on = [volterra_registration_approval.nodes]
  name       = var.instance_name
  when       = "delete"
  state      = "DECOMMISSIONING"
  wait_time  = var.f5xc_registration_wait_time
  retry      = var.f5xc_registration_retry
}

module "site_wait_for_online" {
  depends_on     = [volterra_site_state.decommission_when_delete]
  source         = "../../../status/site"
  f5xc_api_token = var.f5xc_api_token
  f5xc_api_url   = var.f5xc_api_url
  f5xc_namespace = var.f5xc_namespace
  f5xc_site_name = aws_instance.instance.tags["Name"]
  f5xc_tenant    = var.f5xc_tenant
  is_sensitive   = var.is_sensitive
}
