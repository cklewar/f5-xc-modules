resource "google_compute_instance" "compute" {
  name         = var.gcp_compute_instance_machine_name
  machine_type = var.gcp_compute_instance_machine_type
  zone         = element(var.gcp_zone_names, 0)
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

resource "google_compute_firewall" "allow-ssh" {
  name    = var.gcp_compute_firewall_name
  network = format("%s-inside", var.gcp_site_name)

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  //target_tags = ["ssh"]
}