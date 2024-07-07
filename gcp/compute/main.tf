data "cloudinit_config" "config" {
  gzip          = false
  base64_encode = false

  part {
    content      = local.cloud_init_content
    filename     = "config.yaml"
    content_type = "text/cloud-config"
  }
}

resource "google_compute_instance" "compute" {
  name         = var.gcp_compute_instance_machine_name
  zone         = var.gcp_zone_name
  tags         = var.gcp_compute_instance_target_tags
  labels       = var.gcp_compute_instance_labels
  machine_type = var.gcp_compute_instance_machine_type

  boot_disk {
    initialize_params {
      image = var.gcp_google_compute_instance_image
    }
  }

  dynamic "network_interface" {
    for_each = var.gcp_compute_instance_network_interfaces

    content {
      network    = network_interface.value.network_name
      subnetwork = network_interface.value.subnetwork_name
      network_ip = network_interface.value.network_ip

      access_config {
        nat_ip                 = network_interface.value.access_config.nat_ip
        network_tier           = network_interface.value.access_config.network_tier
        public_ptr_domain_name = network_interface.value.access_config.public_ptr_domain_name
      }
    }
  }

  metadata_startup_script = var.gcp_compute_instance_metadata_startup_script != null ? var.gcp_compute_instance_metadata_startup_script : null
  metadata = {
    ssh-keys  = var.ssh_public_key
    user-data = var.gcp_compute_instance_cloud_init_template_data != null ? data.cloudinit_config.config.rendered : null
  }
}