data "http" "nfv_virtual_server_ip" {
  depends_on = [module.f5xc_nfv_wait_for_online]
  url        = format("%s/%s", var.f5xc_api_url, local.nfv_svc_get_uri)

  request_headers = {
    Content-Type  = "application/json"
    Authorization = format("APIToken %s", var.f5xc_api_token)
  }
}

data "aws_instance" "nfv_bigip" {
  depends_on = [module.f5xc_nfv_wait_for_online]
  for_each   = var.f5xc_nfv_type == var.f5xc_nfv_type_f5_big_ip_aws_service ? var.f5xc_aws_nfv_nodes : {}
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_nfv_aws_tgw_site_params.name]
  }

  filter {
    name   = "tag:ves.io/nfv-service-node-name"
    values = [each.key]
  }

  filter {
    name   = "tag:ves-io/nfv-service"
    values = [var.f5xc_nfv_name]
  }

  filter {
    name   = "tag:ves-io/nfv-service-type"
    values = ["bigip"]
  }
}

data "aws_instance" "nfv_pan" {
  depends_on = [module.f5xc_nfv_wait_for_online]
  for_each   = var.f5xc_nfv_type == var.f5xc_nfv_type_palo_alto_fw_service ? var.f5xc_aws_nfv_nodes : {}
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_nfv_aws_tgw_site_params.name]
  }

  filter {
    name   = "tag:ves-io/nfv-service"
    values = [var.f5xc_nfv_name]
  }

  filter {
    name   = "tag:ves-io/nfv-service-type"
    values = ["pan-vmseries-fw"]
  }

  filter {
    name   = "tag:Name"
    values = [format("%s-%s", var.f5xc_nfv_name, each.key)]
  }
}

data "aws_network_interface" "nfv_big_ip_external_interface" {
  depends_on = [module.f5xc_nfv_wait_for_online]
  for_each   = var.f5xc_nfv_type == var.f5xc_nfv_type_f5_big_ip_aws_service ? var.f5xc_aws_nfv_nodes : {}
  filter {
    name   = "tag:Name"
    values = ["BIGIP-External-Private-Interface-0"]
  }

  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_nfv_aws_tgw_site_params.name]
  }

  filter {
    name   = "tag:ves.io/nfv-service-node-name"
    values = [each.key]
  }

  filter {
    name   = "tag:ves-io/nfv-service"
    values = [var.f5xc_nfv_name]
  }

  filter {
    name   = "tag:ves-io/nfv-service-type"
    values = ["bigip"]
  }
}

data "aws_network_interface" "nfv_big_ip_internal_interface" {
  depends_on = [module.f5xc_nfv_wait_for_online]
  for_each   = var.f5xc_nfv_type == var.f5xc_nfv_type_f5_big_ip_aws_service ? var.f5xc_aws_nfv_nodes : {}

  filter {
    name   = "tag:Name"
    values = ["BIGIP-Internal-Interface-0"]
  }

  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_nfv_aws_tgw_site_params.name]
  }

  filter {
    name   = "tag:ves.io/nfv-service-node-name"
    values = [each.key]
  }

  filter {
    name   = "tag:ves-io/nfv-service"
    values = [var.f5xc_nfv_name]
  }

  filter {
    name   = "tag:ves-io/nfv-service-type"
    values = ["bigip"]
  }
}