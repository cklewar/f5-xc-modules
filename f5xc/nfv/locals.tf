locals {
  random_id             = uuid()
  nfv_create_uri        = format(var.f5xc_nfv_svc_create_uri, var.f5xc_namespace)
  nfv_delete_uri        = format(var.f5xc_nfv_svc_delete_uri, var.f5xc_namespace)
  nfv_svc_get_uri       = format(var.f5xc_nfv_svc_get_uri, var.f5xc_namespace, var.f5xc_nfv_name)
  nfv_virtual_server_ip = (jsondecode(data.http.nfv_virtual_server_ip.response_body).status[*].vip)[0]
  manifest_content      = templatefile(format("%s/templates/%s", path.module, var.f5xc_nfv_payload_template), {
    tenant             = var.f5xc_tenant
    namespace          = var.f5xc_namespace
    ssh_key            = var.ssh_public_key
    aws_az_name        = var.f5xc_aws_az_name
    tgw_name           = var.f5xc_tgw_name
    nfv_name           = var.f5xc_nfv_name
    nfv_domain_suffix  = var.f5xc_nfv_domain_suffix
    nfv_node_name      = var.f5xc_nfv_node_name
    nfv_admin_username = var.f5xc_nfv_admin_username
    nfv_admin_password = format("%s%s", "string:///", base64encode(var.f5xc_nfv_admin_password))
    nfv_description    = var.f5xc_nfv_description
    labels             = var.f5xc_nfv_labels
    tags               = var.custom_tags
  })
}