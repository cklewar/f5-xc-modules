output "ce" {
  value = {
    id        = google_compute_instance.instance.id
    sli_ip    = google_compute_instance.instance.network_interface[0].network_ip
    public_ip = google_compute_instance.instance.network_interface[0].access_config[0].nat_ip
  }
}