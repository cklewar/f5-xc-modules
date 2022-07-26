resource "volterra_bgp" "bgp" {
  name      = var.f5xc_bgp_name
  namespace = var.f5xc_namespace

  bgp_parameters {
    asn                = var.f5xc_bgp_asn
    bgp_router_id_type = var.f5xc_bgp_router_id_type
    local_address      = var.f5xc_bgp_local_address
  }

  peers {
    metadata {
      description = var.f5xc_bgp_description
      name        = var.f5xc_bgp_peer_name
    }

    target_service = var.f5xc_bgp_target_service

    external {
      address = var.f5xc_bgp_peer_address
      asn     = var.f5xc_bgp_peer_asn
      port    = var.f5xc_bgp_port

      interface {
        name      = var.f5xc_bgp_interface_name
        namespace = var.f5xc_namespace
        tenant    = var.f5xc_tenant
      }
    }
  }

  where {
    site {
      network_type = var.f5xc_bgp_network_type

      ref {
        name      = var.f5xc_site_name
        namespace = var.f5xc_namespace
        tenant    = var.f5xc_tenant
      }
    }
  }
}