output "ce" {
  value = {
    slo_fw = google_compute_firewall.slo
    sli_fw = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? google_compute_firewall.sli : null
  }
}