output "ce" {
  value = {
    for k, v in data.google_compute_instance.instances : v.name => v if data.google_compute_instance.instances[k].name != null
  }
}