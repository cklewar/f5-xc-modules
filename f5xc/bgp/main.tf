resource "volterra_bgp" "bgp" {
  name      = var.f5xc_bgp_name
  namespace = var.f5xc_namespace

  bgp_parameters {
    asn                = var.f5xc_bgp_asn
    local_address      = var.f5xc_bgp_local_address
    bgp_router_id_type = var.f5xc_bgp_router_id_type
  }

  peers {
    target_service        = var.f5xc_bgp_target_service
    passive_mode_disabled = var.f5xc_bgp_peer_passive_mode_disabled

    metadata {
      name        = var.f5xc_bgp_peer_name
      description = var.f5xc_bgp_description
    }

    external {
      asn     = var.f5xc_bgp_peer_asn
      port    = var.f5xc_bgp_port
      address = var.f5xc_bgp_peer_address

      interface {
        name      = var.f5xc_bgp_interface_name
        tenant    = local.f5xc_tenant
        namespace = var.f5xc_namespace
      }
    }
  }

  where {
    site {
      network_type = var.f5xc_bgp_network_type
      disable_internet_vip = var.f5xc_bgp_site_disable_internet_vip

      ref {
        name      = var.f5xc_site_name
        tenant    = local.f5xc_tenant
        namespace = var.f5xc_namespace
      }
    }
  }
}