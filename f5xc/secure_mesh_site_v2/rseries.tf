locals {
  spec_rseries = var.f5xc_sms_provider_name == "rseries" ? jsonencode({
    not_managed = {
      node_list = [
        {
          type      = string
          hostname  = string
          public_ip = string
          interface_list = [
            {
              description = string
              labels = {
                additionalProp1 = "string"
                additionalProp2 = "string"
                additionalProp3 = "string"
              }
              ethernet_interface = {
                device = string
                mac    = string
              }
              vlan_interface = {
                device  = string
                vlan_id = 0
              }
              bond_interface = {
                name = string
                devices = [
                  string
                ]
                lacp = {
                  rate = 0
                }
                active_backup = {}
                link_polling_interval = 0
                link_up_delay         = 0
              }
              dhcp_client = {}
              static_ip = {
                ip_address = string
                default_gw = string
                dns_server = string
              }
              dhcp_server = {
                dhcp_networks = [
                  {
                    network_prefix = string
                    network_prefix_allocator = {
                      tenant    = string
                      namespace = string
                      name      = string
                    }
                    pools = [
                      {
                        start_ip = string
                        end_ip   = string
                        exclude  = true
                      }
                    ]
                    first_address = {}
                    last_address = {}
                    dgw_address   = string
                    same_as_dgw = {}
                    dns_address   = string
                    pool_settings = INCLUDE_IP_ADDRESSES_FROM_DHCP_POOLS
                  }
                ]
                automatic_from_start = {}
                automatic_from_end = {}
                interface_ip_map = {
                  interface_ip_map = {
                    additionalProp1 = string
                    additionalProp2 = string
                    additionalProp3 = string
                  }
                }
                fixed_ip_map = {
                  additionalProp1 = string
                  additionalProp2 = string
                  additionalProp3 = string
                }
                dhcp_option82_tag = string
              }
              no_ipv4_address = {}
              name = string
              mtu  = 0
              network_option = {
                site_local_network = {}
                site_local_inside_network = {}
                segment_network = {
                  tenant    = string
                  namespace = string
                  name      = string
                }
              }
              monitor_disabled = {}
              monitor = {}
              priority      = 0
              site_to_site_connectivity_interface_disabled = {}
              site_to_site_connectivity_interface_enabled = {}
              is_primary    = true
              is_management = true
              no_ipv6_address = {}
              static_ipv6_address = {
                node_static_ip = {
                  ip_address = string
                  default_gw = string
                  dns_server = string
                }
                cluster_static_ip = {
                  interface_ip_map = {
                    additionalProp1 = {
                      ip_address = string
                      default_gw = string
                      dns_server = string
                    }
                    additionalProp2 = {
                      ip_address = string
                      default_gw = string
                      dns_server = string
                    }
                    additionalProp3 = {
                      ip_address = string
                      default_gw = string
                      dns_server = string
                    }
                  }
                }
                fleet_static_ip = {
                  network_prefix_allocator = {
                    tenant    = string
                    namespace = string
                    name      = string
                  }
                  default_gw = string
                  dns_server = string
                }
              }
              ipv6_auto_config = {
                host = {}
                router = {
                  network_prefix = string
                  stateful = {
                    dhcp_networks = [
                      {
                        network_prefix = string
                        network_prefix_allocator = {
                          tenant    = string
                          namespace = string
                          name      = string
                        }
                        pools = [
                          {
                            start_ip = string
                            end_ip   = string
                            exclude  = true
                          }
                        ]
                        pool_settings = INCLUDE_IP_ADDRESSES_FROM_DHCP_POOLS
                      }
                    ]
                    automatic_from_start = {}
                    automatic_from_end = {}
                    interface_ip_map = {
                      interface_ip_map = {
                        additionalProp1 = string
                        additionalProp2 = string
                        additionalProp3 = string
                      }
                    }
                    fixed_ip_map = {
                      additionalProp1 = string
                      additionalProp2 = string
                      additionalProp3 = string
                    }
                  }
                  dns_config = {
                    local_dns = {
                      first_address = {}
                      last_address = {}
                      configured_address = string
                    }
                    configured_list = {
                      dns_list = [
                        string
                      ]
                    }
                  }
                }
              }
            }
          ]
        }
      ]
    }
  }) : null
}