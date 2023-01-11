output "ce" {
  value = {
    id           = google_compute_instance.instance.id
    name         = google_compute_instance.instance.name
    zone         = google_compute_instance.instance.zone
    tags         = google_compute_instance.instance.tags
    labels       = google_compute_instance.instance.labels
    sli_ip       = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? google_compute_instance.instance.network_interface[1].network_ip : null
    slo_ip       = google_compute_instance.instance.network_interface[0].network_ip
    metadata     = google_compute_instance.instance.metadata
    public_ip    = google_compute_instance.instance.network_interface[0].access_config[0].nat_ip
    instance_id  = google_compute_instance.instance.instance_id
    machine_type = google_compute_instance.instance.machine_type
  }
}