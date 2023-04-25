data "aws_ami" "butane" {
  most_recent = true
  owners      = [var.butane_ami_owner_id]

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
  content = templatefile("./templates/ce.yaml", {
    site_label      = var.f5xc_site_label,
    site_token      = var.f5xc_site_token,
    cluster_name    = var.f5xc_site_name,
    ssh_public_key  = var.ssh_public_key,
    custom_vip_cidr = var.custom_vip_cidr
  })
  strict = true
}