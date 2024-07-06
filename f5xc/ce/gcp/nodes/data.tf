data "google_compute_region_instance_group" "instance_group" {
  depends_on = [google_compute_region_instance_group_manager.instance_group_manager]
  self_link  = google_compute_region_instance_group_manager.instance_group_manager.instance_group
}

data "google_compute_instance" "instances" {
  depends_on = [data.google_compute_region_instance_group.instance_group]
  count      = var.f5xc_cluster_size
  self_link  = data.google_compute_region_instance_group.instance_group.instances[count.index].instance
}