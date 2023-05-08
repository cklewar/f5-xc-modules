output "ce" {
  value = {
    for k, v in data.google_compute_instance.instances : v.name => v if data.google_compute_instance.instances[k].name != null
  }
}

/*
id          = google_compute_instance.instance.id
name        = google_compute_instance.instance.name
tags        = google_compute_instance.instance.tags
labels      = google_compute_instance.instance.labels
sli_ip      = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? google_compute_instance.instance.network_interface[1].network_ip : null
slo_ip      = google_compute_instance.instance.network_interface[0].network_ip
public_ip   = var.has_public_ip ? google_compute_instance.instance.network_interface[0].access_config[0].nat_ip : ""
instance_id = google_compute_instance.instance.instance_id
*/