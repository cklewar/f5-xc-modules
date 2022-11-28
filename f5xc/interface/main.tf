resource "volterra_network_interface" "ethernet_interface" {
  count       = var.f5xc_interface_type == var.f5xc_interface_type_ethernet_interface ? 1 : 0
  name        = var.f5xc_interface_name
  namespace   = var.f5xc_namespace
  description = var.f5xc_interface_description

  ethernet_interface {
    device                    = var.f5xc_interface_ethernet_interface_device
    mtu                       = var.f5xc_interface_mtu
    monitor_disabled          = var.f5xc_interface_monitor_disabled
    cluster                   = var.f5xc_apply_to_cluster
    node                      = var.f5xc_apply_to_node
    is_primary                = var.f5xc_interface_is_primary
    not_primary               = var.f5xc_interface_not_primary
    priority                  = var.f5xc_interface_priority
    untagged                  = var.f5xc_interface_untagged
    vlan_id                   = var.f5xc_interface_vlan_id
    site_local_inside_network = var.f5xc_interface_site_local_inside_network
    site_local_network        = var.f5xc_interface_site_local_network

    dynamic "static_ip" {
      for_each = var.f5xc_interface_static_ip_interface_ip_map != "" ? [1] : []
      content {
        dynamic "node_static_ip" {
          for_each = var.f5xc_interface_static_ip_node_static_ip != "" ? [1] : []
          content {
            default_gw = var.f5xc_interface_default_gw
            dns_server = var.f5xc_interface_dns_server
            ip_address = var.f5xc_interface_static_ip_node_static_ip
          }
        }
      }
    }

    dhcp_client = var.f5xc_interface_dhcp_client

    dynamic "dhcp_server" {
      for_each = length(var.f5xc_interface_dhcp_networks_pools) > 0 ? [1] : []
      content {
        fixed_ip_map         = var.f5xc_interface_dhcp_server_fixed_ip_map
        automatic_from_start = var.f5xc_interface_dhcp_server_automatic_from_start
        automatic_from_end   = var.f5xc_interface_dhcp_server_automatic_from_end
        dhcp_option82_tag    = var.f5xc_interface_dhcp_option82_tag
        interface_ip_map {
          interface_ip_map = var.f5xc_interface_dhcp_server_interface_ip_map
        }

        dynamic "dhcp_networks" {
          for_each = var.f5xc_interface_dhcp_networks_pools
          content {
            dns_address    = try(dhcp_networks.value.dns_address, null)
            same_as_dgw    = try(dhcp_networks.value.same_as_dgw, null)
            dgw_address    = try(dhcp_networks.value.dgw_address, null)
            first_address  = try(dhcp_networks.value.first_address, null)
            last_address   = try(dhcp_networks.value.last_address, null)
            network_prefix = dhcp_networks.value.network_prefix
            pool_settings  = var.f5xc_interface_dhcp_networks_pool_settings
            dynamic "pools" {
              for_each = dhcp_networks.value.pools
              content {
                exclude  = pools.value.exclude
                start_ip = pools.value.start_ip
                end_ip   = pools.value.end_ip
              }
            }
          }
        }
      }
    }
  }
}

resource "local_file" "tunnel_interface" {
  count    = var.f5xc_interface_type == var.f5xc_interface_type_tunnel_interface ? 1 : 0
  content  = local.tunnel_interface_content
  filename = format("%s/_out/%s", path.root, var.f5xc_interface_payload_file)
}

resource "null_resource" "apply_interface" {
  count    = var.f5xc_interface_type == var.f5xc_interface_type_tunnel_interface ? 1 : 0
  triggers = {
    manifest_sha1  = sha1(local.tunnel_interface_content)
    api_url        = var.f5xc_api_url
    api_token      = var.f5xc_api_token
    delete_uri     = local.interface_delete_uri
    namespace      = var.f5xc_namespace
    interface_name = var.f5xc_interface_name
  }

  provisioner "local-exec" {
    command     = format("curl -v -X 'POST' %s/%s -H 'Content-Type: application/json' -H 'Authorization: APIToken %s' -d '%s'", var.f5xc_api_url, local.interface_create_uri, var.f5xc_api_token, local.tunnel_interface_content)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "${path.module}/scripts/delete.sh"
    on_failure  = continue
    environment = {
      api_token      = self.triggers.api_token
      api_url        = self.triggers.api_url
      delete_uri     = self.triggers.delete_uri
      namespace      = self.triggers.namespace
      interface_name = self.triggers.interface_name
    }
  }
}