output "ce" {
  value = {
    master-0 = {
      id          = google_compute_instance.instance.id
      name        = google_compute_instance.instance.name
      tags        = google_compute_instance.instance.tags
      labels      = google_compute_instance.instance.labels
      sli_ip      = google_compute_instance.instance.network_interface[1].network_ip
      slo_ip      = google_compute_instance.instance.network_interface[0].network_ip
      public_ip   = google_compute_instance.instance.network_interface[0].access_config[0].nat_ip
      instance_id = google_compute_instance.instance.instance_id
    }
  }
}