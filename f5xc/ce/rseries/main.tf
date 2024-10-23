module "sms" {
  source                         = "../../secure_mesh_site_v2"
  f5xc_tenant                    = var.f5os_tenant
  f5xc_api_url                   = var.f5xc_api_url
  f5xc_api_token                 = var.f5xc_api_token
  f5xc_namespace                 = var.f5xc_namespace
  f5xc_sms_name                  = var.f5xc_site_name
  f5xc_sms_labels                = var.f5xc_sms_labels
  f5xc_sms_provider_name         = var.f5xc_sms_provider_name
  f5xc_sms_master_nodes_count    = var.f5xc_sms_master_nodes_count
  f5xc_sms_perf_mode_l7_enhanced = var.f5xc_sms_perf_mode_l7_enhanced
  f5xc_dc_cluster_group_slo_name = var.f5xc_dc_cluster_group_slo_name
  f5xc_dc_cluster_group_sli_name = var.f5xc_dc_cluster_group_sli_name
  providers = {
    restapi = restapi.f5xc
  }
}

resource "restful_resource" "f5os_tenant" {
  path        = var.f5os_tenant_base_uri
  provider    = restapi.f5os
  read_path   = "${var.f5os_tenant_base_uri}${var.f5os_tenant_delete_path}${var.f5os_tenant}"
  delete_path = "${var.f5os_tenant_base_uri}${var.f5os_tenant_delete_path}${var.f5os_tenant}"
  header = {
    Content-Type = "application/json"
  }
  body = jsonencode(
    {
      tenant = [
        {
          name = var.f5os_tenant
          config = {
            type                   = var.f5os_tenant_config_type
            image                  = var.f5os_tenant_config_image
            nodes                  = var.f5os_tenant_config_nodes
            vlans                  = var.f5os_tenant_config_vlans
            memory                 = var.f5os_tenant_config_memory == 0 ? (4.0 * 1024 * var.f5os_tenant_config_vcpu_cores_per_node) : var.f5os_tenant_config_memory
            cryptos                = var.f5os_tenant_config_cryptos
            dhcp-enabled           = var.f5os_tenant_config_dhcp_enabled
            running-state          = var.f5os_tenant_config_running_state
            dag-ipv6-prefix-length = var.f5os_tenant_config_dag_ipv6_prefix_length
            "f5-tenant-metadata:metadata" = concat(["token:${module.sms.secure_mesh_site.token.key}"], var.f5os_tenant_config_metadata)
            vcpu-cores-per-node    = var.f5os_tenant_config_vcpu_cores_per_node
            storage = {
              size = var.f5os_tenant_config_storage_size
            }
            mac-data = {
              "f5-tenant-l2-inline:mac-block-size" = var.f5os_tenant_config_l2_inline_mac_block_size
            }
          }
        }
      ]
    }
  )
}

module "site_wait_for_online" {
  depends_on = [restful_resource.f5os_tenant]
  source                     = "../../status/site"
  count                      = var.wait_for_online ? 1 : 0
  is_sensitive               = var.is_sensitive
  f5xc_tenant                = var.f5xc_tenant
  f5xc_api_url               = var.f5xc_api_url
  f5xc_api_token             = var.f5xc_api_token
  f5xc_site_name             = var.f5xc_site_name
  f5xc_namespace             = var.f5xc_namespace
  f5xc_api_p12_file          = var.f5xc_api_p12_file
  status_check_type          = var.status_check_type
  f5xc_api_p12_cert_password = var.f5xc_api_p12_cert_password
}

module "update_interface" {
  depends_on = [module.site_wait_for_online]
  count               = var.f5xc_ce_gw_type == var.f5xc_ce_gateway_type_ingress_egress ? 1 : 0
  source              = "../../../utils/update"
  del_key             = ""
  merge_key           = "rseries.not_managed.node_list[0].interface_list"
  merge_data          = jsonencode(var.f5xc_ce_interface_list)
  f5xc_tenant         = var.f5xc_tenant
  f5xc_api_url        = var.f5xc_api_url
  f5xc_namespace      = var.f5xc_namespace
  f5xc_api_token      = var.f5xc_api_token
  f5xc_api_get_uri    = "config/namespaces/${var.f5xc_namespace}/securemesh_site_v2s/${var.f5xc_site_name}"
  f5xc_api_update_uri = "config/namespaces/${var.f5xc_namespace}/securemesh_site_v2s/${var.f5xc_site_name}"
  providers = {
    http-full = http-full.default
  }
}