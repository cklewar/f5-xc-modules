resource "aws_instance" "instance" {
  ami                  = var.instance_image
  instance_type        = var.instance_type
  user_data_base64     = base64encode(var.instance_config)
  monitoring           = var.instance_monitoring
  key_name             = var.public_ssh_key_name
  iam_instance_profile = var.iam_instance_profile_id
  tags                 = local.common_tags

  root_block_device {
    volume_size = var.machine_disk_size
  }

  network_interface {
    network_interface_id = var.interface_slo_id
    device_index         = "0"
  }

  dynamic "network_interface" {
    for_each = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? [1] : []
    content {
      network_interface_id = var.interface_sli_id
      device_index         = "1"
    }
  }

  timeouts {
    create = var.instance_create_timeout
    delete = var.instance_delete_timeout
  }
}

/*resource "aws_lb_target_group_attachment" "volterra_ce_attachment" {
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.instance.id
  port             = 6443
}*/

resource "volterra_registration_approval" "nodes" {
  depends_on   = [aws_instance.instance]
  cluster_name = var.cluster_name
  cluster_size = var.cluster_size
  hostname     = regex("[0-9A-Za-z_-]+", aws_instance.instance.private_dns) #var.node_name
  wait_time    = var.f5xc_registration_wait_time
  retry        = var.f5xc_registration_retry
}

resource "volterra_site_state" "decommission_when_delete" {
  depends_on = [volterra_registration_approval.nodes]
  name       = var.node_name
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
  f5xc_site_name = var.cluster_name
  f5xc_tenant    = var.f5xc_tenant
  is_sensitive   = var.is_sensitive
}
