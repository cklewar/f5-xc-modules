resource "google_compute_instance" "instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  boot_disk {
    initialize_params {
      image = var.image
      size  = var.machine_disk_size
    }
  }
  network_interface {
    subnetwork = var.slo_subnetwork
    access_config {}
  }
  network_interface {
    subnetwork = var.sli_subnetwork
    access_config {}
  }
  metadata = {
    ssh-keys  = "centos:${var.ssh_public_key}"
    user-data = var.user_data
  }
  service_account {
    scopes = ["cloud-platform"]
  }
}

resource "volterra_registration_approval" "nodes" {
  depends_on   = [google_compute_instance.instance]
  cluster_name = var.instance_name
  cluster_size = var.cluster_size
  hostname     = var.instance_name
  wait_time    = var.registration_wait_time
  retry        = var.registration_retry
}

resource "volterra_site_state" "decommission_when_delete" {
  depends_on = [volterra_registration_approval.nodes]
  name       = var.instance_name
  when       = "delete"
  state      = "DECOMMISSIONING"
  wait_time  = var.registration_wait_time
  retry      = var.registration_retry
}
