data "aws_ami" "coreos" {
  owners      = [var.coreos_ami_owner_id]
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
    k0s_version     = var.k0s_version,
    cluster_name    = var.f5xc_site_name,
    cluster_labels  = var.f5xc_cluster_labels,
    butane_variant  = var.butane_variant,
    butane_version  = var.butane_version,
    ssh_public_key  = var.ssh_public_key,
    custom_vip_cidr = var.f5xc_custom_vip_cidr
  })
  strict = true
}