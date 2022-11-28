output "ip_address" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}

output "private_ip_address" {
  value = google_compute_instance.vm_instance.network_interface[0].network_ip
}

output "google_compute_instance_id" {
  value = google_compute_instance.vm_instance.id
}