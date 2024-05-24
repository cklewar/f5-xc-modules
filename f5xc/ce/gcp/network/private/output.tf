output "ce" {
  value = {
    nat    = google_compute_address.address.0
    router = module.router
  }
}