resource "google_compute_instance" "compute" {
  name         = var.gcp_compute_instance_machine_name
  machine_type = var.gcp_compute_instance_machine_type
  zone         = var.gcp_zone_name
  //tags         = ["ssh"]

  boot_disk {
    initialize_params {
      image = var.gcp_google_compute_instance_image
    }
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.subnetwork_inside.name
    access_config {}
  }

  metadata_startup_script = var.gcp_compute_instance_metadata_startup_script

  metadata = {
    ssh-keys = var.public_ssh_key
  }
}