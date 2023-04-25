data "http" "nfv_virtual_server_ip" {
  depends_on = [module.f5xc_nfv_wait_for_online]
  count      = var.f5xc_nfv_type == var.f5xc_nfv_type_f5_big_ip_aws_service ? 1 : 0
  url        = format("%s/%s", var.f5xc_api_url, local.nfv_svc_get_uri)

  request_headers = {
    Content-Type  = "application/json"
    Authorization = format("APIToken %s", var.f5xc_api_token)
  }
}

data "aws_instance" "nfv_bigip_node1" {
  depends_on = [module.f5xc_nfv_wait_for_online]
  for_each   = var.f5xc_nfv_type == var.f5xc_nfv_type_f5_big_ip_aws_service ? { keys(var.f5xc_aws_nfv_nodes)[0] = lookup(var.f5xc_aws_nfv_nodes, keys(var.f5xc_aws_nfv_nodes)[0]) } : {}
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_nfv_aws_tgw_site_params.name]
  }

  filter {
    name   = "tag:ves.io/nfv-service-node-name"
    values = [each.key]
  }

  filter {
    name   = "tag:f5xc-tenant"
    values = [var.f5xc_tenant]
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

data "aws_instance" "nfv_bigip_node2" {
  depends_on = [module.f5xc_nfv_wait_for_online]
  for_each   = var.f5xc_nfv_type == var.f5xc_nfv_type_f5_big_ip_aws_service && length(var.f5xc_aws_nfv_nodes) > 1 ? {
    keys(var.f5xc_aws_nfv_nodes)[1] = lookup(var.f5xc_aws_nfv_nodes, keys(var.f5xc_aws_nfv_nodes)[1])
  } : {}
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_nfv_aws_tgw_site_params.name]
  }

  filter {
    name   = "tag:ves-io-nfv-service-node-name"
    values = [each.key]
  }

  filter {
    name   = "tag:f5xc-tenant"
    values = [var.f5xc_tenant]
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

data "aws_network_interface" "nfv_big_ip_external_interface_node1" {
  depends_on = [module.f5xc_nfv_wait_for_online]
  for_each   = var.f5xc_nfv_type == var.f5xc_nfv_type_f5_big_ip_aws_service ? { keys(var.f5xc_aws_nfv_nodes)[0] = lookup(var.f5xc_aws_nfv_nodes, keys(var.f5xc_aws_nfv_nodes)[0]) } : {}
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

data "aws_network_interface" "nfv_big_ip_internal_interface_node1" {
  depends_on = [module.f5xc_nfv_wait_for_online]
  for_each   = var.f5xc_nfv_type == var.f5xc_nfv_type_f5_big_ip_aws_service ? { keys(var.f5xc_aws_nfv_nodes)[0] = lookup(var.f5xc_aws_nfv_nodes, keys(var.f5xc_aws_nfv_nodes)[0]) } : {}

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

data "aws_network_interface" "nfv_big_ip_external_interface_node2" {
  depends_on = [module.f5xc_nfv_wait_for_online]
  for_each   = var.f5xc_nfv_type == var.f5xc_nfv_type_f5_big_ip_aws_service && local.is_cluster ? { keys(var.f5xc_aws_nfv_nodes)[1] = lookup(var.f5xc_aws_nfv_nodes, keys(var.f5xc_aws_nfv_nodes)[1]) } : {}
  filter {
    name   = "tag:Name"
    values = ["BIGIP-External-Private-Interface-0"]
  }

  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_nfv_aws_tgw_site_params.name]
  }

  filter {
    name   = "tag:ves-io-nfv-service-node-name"
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


data "aws_network_interface" "nfv_big_ip_internal_interface_node2" {
  depends_on = [module.f5xc_nfv_wait_for_online]
  for_each   = var.f5xc_nfv_type == var.f5xc_nfv_type_f5_big_ip_aws_service && local.is_cluster ? { keys(var.f5xc_aws_nfv_nodes)[1] = lookup(var.f5xc_aws_nfv_nodes, keys(var.f5xc_aws_nfv_nodes)[1]) } : {}

  filter {
    name   = "tag:Name"
    values = ["BIGIP-Internal-Interface-0"]
  }

  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_nfv_aws_tgw_site_params.name]
  }

  filter {
    name   = "tag:ves-io-nfv-service-node-name"
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

data "http" "pan_commands" {
  depends_on      = [module.f5xc_nfv_wait_for_online]
  count           = var.f5xc_nfv_type == var.f5xc_nfv_type_palo_alto_fw_service ? 1 : 0
  url             = format("%s/%s?response_format=GET_RSP_FORMAT_DEFAULT", var.f5xc_api_url, local.nfv_svc_get_uri)
  request_headers = {
    Accept                      = "application/json"
    Authorization               = format("APIToken %s", var.f5xc_api_token)
    x-volterra-apigw-tenant     = var.f5xc_tenant
    Access-Control-Allow-Origin = "*"
  }
}