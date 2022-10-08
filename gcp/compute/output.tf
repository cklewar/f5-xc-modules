output "gcp_compute" {
  value = {
    "id"                = google_compute_instance.compute.id
    "name"              = google_compute_instance.compute.name
    "network_interface" = google_compute_instance.compute.network_interface
    "machine_type"      = google_compute_instance.compute.machine_type
    "current_status"    = google_compute_instance.compute.current_status
    "hostname"          = google_compute_instance.compute.hostname
  }
}