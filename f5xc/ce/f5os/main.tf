/*resource "restapi_object" "secure_mesh_site" {
  provider = restapi.f5xc
  path     = "/api/objects"
  data = jsonencode("")
}*/

resource "restapi_object" "f5os_tenant" {
  provider     = restapi.f5os
  path         = "/f5-tenants:tenants"
  id_attribute = "tenant/name"
  data = jsonencode(
    {
      "tenant" : [
        {
          "name" : var.f5os_tenant,
          "config" : {
            "type" : var.f5os_tenant_config_type
            "image" : var.f5os_tenant_config_image,
            "nodes" : var.f5os_tenant_config_nodes,
            "dhcp-enabled" : var.f5os_tenant_config_dhcp_enabled,
            "dag-ipv6-prefix-length" : var.f5os_tenant_config_dag_ipv6_prefix_length,
            "vlans" : var.f5os_tenant_config_vlans,
            "vcpu-cores-per-node" : var.f5os_tenant_config_vcpu_cores_per_node,
            "memory" : var.f5os_tenant_config_memory,
            "storage" : {
              "size" : var.f5os_tenant_config_storage_size
            },
            "cryptos" : var.f5os_tenant_config_cryptos,
            "mac-data" : {
              "f5-tenant-l2-inline:mac-block-size" : var.f5os_tenant_config_l2_inline_mac_block_size
            },
            "running-state" : var.f5os_tenant_config_running_state,
            "f5-tenant-metadata:metadata" : var.f5os_tenant_config_metadata
          }
        }
      ]
    }
  )
}