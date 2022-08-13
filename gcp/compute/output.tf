output "gcp_compute" {
  value = {
    "id"   = google_compute_instance.compute.id
    "name" = google_compute_instance.compute.name
  }
}