output "gcp_compute" {
  value = {
    "id"                = google_compute_instance.compute.id
    "name"              = google_compute_instance.compute.name
    #"nat_ip"            = google_compute_instance.compute.network_interface[0]["access_config"][0]["nat_ip"]
    "nat_ip"            = google_compute_instance.compute.network_interface
    "hostname"          = google_compute_instance.compute.hostname
    #"network_ip"        = google_compute_instance.compute.network_interface[0]["network_ip"]
    "network_ip"        = google_compute_instance.compute.network_interface
    "machine_type"      = google_compute_instance.compute.machine_type
    "current_status"    = google_compute_instance.compute.current_status
    "network_interface" = google_compute_instance.compute.network_interface
  }
}