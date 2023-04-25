locals {
  is_cluster            = length(var.f5xc_aws_nfv_nodes) > 1 ? true : false
  f5xc_tenant           = var.is_sensitive ? sensitive(var.f5xc_tenant) : var.f5xc_tenant
  f5xc_api_token        = var.is_sensitive ? sensitive(var.f5xc_api_token) : var.f5xc_api_token
  nfv_svc_get_uri       = format(var.f5xc_nfv_svc_get_uri, var.f5xc_namespace, var.f5xc_nfv_name)
  nfv_virtual_server_ip = var.f5xc_nfv_type == var.f5xc_nfv_type_f5_big_ip_aws_service ? (jsondecode(data.http.nfv_virtual_server_ip[0].response_body).status[*].vip)[0] : null
}