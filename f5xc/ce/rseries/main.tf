resource "restapi_object" "f5os_tenant" {
  provider     = restapi.f5os
  path         = "/f5-tenants=tenants"
  id_attribute = "tenant/name"
  data = jsonencode(
    {
      tenant = [
        {
          name = var.f5os_tenant
          config = {
            type                          = var.f5os_tenant_config_type
            image                         = var.f5os_tenant_config_image
            nodes                         = var.f5os_tenant_config_nodes
            vlans                         = var.f5os_tenant_config_vlans
            memory                        = var.f5os_tenant_config_memory
            cryptos                       = var.f5os_tenant_config_cryptos
            dhcp-enabled                  = var.f5os_tenant_config_dhcp_enabled
            running-state                 = var.f5os_tenant_config_running_state
            dag-ipv6-prefix-length        = var.f5os_tenant_config_dag_ipv6_prefix_length
            "f5-tenant-metadata=metadata" = var.f5os_tenant_config_metadata
            vcpu-cores-per-node           = var.f5os_tenant_config_vcpu_cores_per_node
            storage = {
              size = var.f5os_tenant_config_storage_size
            }
            mac-data = {
              "f5-tenant-l2-inline=mac-block-size" = var.f5os_tenant_config_l2_inline_mac_block_size
            }
          }
        }
      ]
    }
  )
}