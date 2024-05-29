resource "volterra_token" "token" {
  name      = var.f5xc_cluster_name
  namespace = var.f5xc_namespace
}

resource "libvirt_volume" "volume" {
  name     = "${var.f5xc_node_name}.qcow2"
  pool     = var.kvm_storage_pool
  source   = var.f5xc_qcow2_image
  format   = "qcow2"
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  name      = "${var.f5xc_node_name}-cloud-init.iso"
  pool      = var.kvm_storage_pool
  user_data = data.template_file.user_data.rendered
  meta_data = data.template_file.meta_data.rendered
}

resource "libvirt_domain" "vm" {
  depends_on = [ libvirt_volume.volume, libvirt_cloudinit_disk.cloudinit ]
  name       = var.f5xc_node_name
  memory     = var.kvm_instance_memory_size
  vcpu       = var.kvm_instance_cpu_count

  disk {
    volume_id = libvirt_volume.volume.id
  }

  cpu {
    mode = "host-passthrough"
  }

  cloudinit = libvirt_cloudinit_disk.cloudinit.id

  network_interface {
    network_name = var.kvm_instance_outside_network_name
  }

  dynamic "network_interface" {
    for_each = var.is_multi_nic ? [1] : []
    content {
      network_name = var.kvm_instance_inside_network_name
    }
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }
}

resource "volterra_registration_approval" "ce" {
  depends_on   = [ libvirt_domain.vm ]
  hostname     = var.f5xc_node_name
  cluster_name = var.f5xc_cluster_name
  cluster_size = length(var.f5xc_kvm_site_nodes)

  retry        = var.f5xc_registration_retry
  wait_time    = var.f5xc_registration_wait_time
}

resource "volterra_site_state" "decommission_when_delete" {
  depends_on = [ volterra_registration_approval.ce ]
  name       = var.f5xc_cluster_name
  when       = "delete"
  state      = "DECOMMISSIONING"

  retry      = var.f5xc_registration_retry
  wait_time  = var.f5xc_registration_wait_time
}
