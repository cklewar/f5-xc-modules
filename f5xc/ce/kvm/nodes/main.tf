resource "volterra_token" "token" {
  name      = var.f5xc_cluster_name
  namespace = var.f5xc_namespace
}

resource "libvirt_volume" "volume" {
  name   = "${var.f5xc_node_name}.qcow2"
  pool   = var.kvm_storage_pool
  source = var.f5xc_qcow2_image
  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  name      = "${var.f5xc_node_name}-cloud-init.iso"
  pool      = var.kvm_storage_pool
  user_data = local.user_data
  meta_data = local.meta_data
}

resource "libvirt_domain" "vm" {
  depends_on = [libvirt_volume.volume, libvirt_cloudinit_disk.cloudinit]
  vcpu   = var.kvm_instance_cpu_count
  name   = var.f5xc_node_name
  memory = var.kvm_instance_memory_size

  disk {
    volume_id = libvirt_volume.volume.id
  }

  cpu {
    mode = var.libvirt_domain_cpu_mode
  }

  cloudinit = libvirt_cloudinit_disk.cloudinit.id

  network_interface {
    passthrough = var.kvm_instance_outside_network_name
  }

  dynamic "network_interface" {
    for_each = var.is_multi_nic ? [1] : []
    content {
      passthrough = var.kvm_instance_inside_network_name
    }
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }
}

resource "volterra_registration_approval" "ce" {
  depends_on = [libvirt_domain.vm]
  hostname     = var.f5xc_node_name
  cluster_name = var.f5xc_cluster_name
  cluster_size = length(var.f5xc_kvm_site_nodes)
  retry        = var.f5xc_registration_retry
  wait_time    = var.f5xc_registration_wait_time
}

resource "volterra_site_state" "decommission_when_delete" {
  depends_on = [volterra_registration_approval.ce]
  name      = var.f5xc_cluster_name
  when      = "delete"
  state     = "DECOMMISSIONING"
  retry     = var.f5xc_registration_retry
  wait_time = var.f5xc_registration_wait_time
}
