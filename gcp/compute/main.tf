resource "google_compute_instance" "compute" {
  name         = var.compute_instance_machine_name
  machine_type = var.gcp_compute_instance_machine_type
  zone         = element(var.zone_names, 0)
  //tags         = ["ssh"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.subnetwork_inside.name
    access_config {}
  }

  metadata_startup_script = <<-EOF
#!/bin/bash
sleep 30
sudo apt-get update
sudo apt-get -y install net-tools tcpdump traceroute iputils-ping
EOF

  metadata = {
    ssh-keys = var.public_ssh_key
  }
}

resource "google_compute_firewall" "allow-ssh" {
  name    = var.google_compute_firewall_name
  network = format("%s-inside", var.site_name)

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