output "ce" {
  value = {
    master-0 = {
      slo_subnetwork = google_compute_subnetwork.slo_subnet
      slo_network    = google_compute_network.slo_vpc_network
      sli_subnetwork = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? google_compute_subnetwork.sli_subnet[0] : null
      sli_network    = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? google_compute_network.sli_vpc_network[0] : null
    }
  }
}