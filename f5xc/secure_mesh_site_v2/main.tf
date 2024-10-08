resource "restful_resource" "token" {
  provider = restful.default
  path = format(var.f5xc_token_base_uri, var.f5xc_namespace)
  read_path = format(var.f5xc_token_read_uri, var.f5xc_namespace, var.f5xc_sms_name)
  delete_path = format(var.f5xc_token_read_uri, var.f5xc_namespace, var.f5xc_sms_name)
  header = {
    Content-Type = "application/json"
  }
  body = {
    metadata = {
      name      = var.f5xc_sms_name
      namespace = var.f5xc_namespace
    }
    spec = {
      type      = "JWT"
      site_name = var.f5xc_sms_name
    }
  }
}

/*resource "volterra_securemesh_site_v2" "site" {
  name                    = "acmecorp-web"
  provider                = volterra.default
  namespace               = var.f5xc_namespace
  log_receiver {}
  block_all_services      = true
  logs_streaming_disabled = true

  // One of the arguments from this list "vmware kvm aws azure gcp rseries baremetal oci" must be set
  aws {
    not_managed {
      node_list {
        type      = "Control"
        hostname  = "Control"
        public_ip = "1.1.1.1"

        interface_list {
          mtu                                          = "1450"
          name                                         = "eth0"
          monitor {}
          priority                                     = "42"
          description                                  = "value"
          no_ipv6_address                              = true
          ipv6_auto_config {}
          static_ipv6_address {}
          monitor_disabled                             = true
          site_to_site_connectivity_interface_disabled = true
          site_to_site_connectivity_interface_enabled  = false

          labels = {
            "key1" = "value1"
          }

          network_option {
            // One of the arguments from this list "site_local_inside_network segment_network site_local_network" can be set
            site_local_network = true
          }
        }

        interface_list {
          mtu                                          = "1450"
          name                                         = "eth1"
          monitor {}
          priority                                     = "42"
          description = "value"
          // One of the arguments from this list "ipv6_auto_config no_ipv6_address static_ipv6_address" can be set
          no_ipv6_address                              = true
          monitor_disabled                             = true
          site_to_site_connectivity_interface_disabled = true
          site_to_site_connectivity_interface_enabled  = false

          // One of the arguments from this list "dhcp_client static_ip dhcp_server no_ipv4_address" must be set
          /*dhcp_server {
            dhcp_networks {
              // One of the arguments from this list "same_as_dgw dns_address" must be set
              same_as_dgw = true
              // One of the arguments from this list "first_address last_address dgw_address" must be set
              first_address = true
              // One of the arguments from this list "network_prefix network_prefix_allocator" must be set
              network_prefix       = "10.1.1.0/24"
              pool_settings = "pool_settings"
              // One of the arguments from this list "automatic_from_start automatic_from_end interface_ip_map" must be set
              automatic_from_start = true

              pools {
                end_ip   = "10.1.1.200"
                start_ip = "10.1.1.5"
              }
            }

            fixed_ip_map = {
              "key1" = "value1"
            }
          }*/

// One of the arguments from this list "ethernet_interface vlan_interface bond_interface" must be set
/*bond_interface {
  devices = ["eth0"]

  // One of the arguments from this list "lacp active_backup" must be set

  lacp {
    rate = "30"
  }
  link_polling_interval = "1000"
  link_up_delay         = "200"
  name                  = "bond0"
}*/

/*labels = {
  "key1" = "value1"
}

network_option {
  site_local_inside_network = true
}
}
}
}
}
}*/