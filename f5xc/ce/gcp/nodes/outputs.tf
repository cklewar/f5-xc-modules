output "ce" {
  value = {
    for k, v in data.google_compute_instance.instances : v.name => v if data.google_compute_instance.instances[k].name != null
  }
}


output "google_compute_region_instance_group" {
  value = data.google_compute_region_instance_group.instance_group
}