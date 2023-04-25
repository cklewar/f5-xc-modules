data "aws_ami" "butane" {
  owners      = [var.butane_ami_owner_id]
  most_recent = true

  filter {
    name   = "name"
    values = ["fedora-coreos-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "ct_config" "config" {
  content = templatefile(var.ce_config_template_file, {
    site_token      = var.f5xc_site_token,
    cluster_name    = var.f5xc_site_name,
    cluster_labels  = var.f5xc_cluster_labels,
    ssh_public_key  = var.ssh_public_key,
    custom_vip_cidr = var.f5xc_custom_vip_cidr
  })
  strict = true
}