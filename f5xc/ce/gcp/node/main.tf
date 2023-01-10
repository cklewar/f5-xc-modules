resource "google_compute_instance" "instance" {
  name         = var.name
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

resource "volterra_registration_approval" "master_nodes" {
  depends_on   = [google_compute_instance.instance]
  cluster_name = var.name
  cluster_size = 1
  hostname     = var.name
  wait_time    = 60
  retry        = 20
}

resource "volterra_site_state" "decommission_when_delete" {
  depends_on = [volterra_registration_approval.master_nodes]
  name       = var.name
  when       = "delete"
  state      = "DECOMMISSIONING"
  wait_time  = 60
  retry      = 5
}
