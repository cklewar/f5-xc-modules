data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "ds" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host" {
  name          = var.vsphere_host
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "outside" {
  name          = var.vsphere_instance_outside_network_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "inside" {
  count         = var.is_multi_nic ? 1 : 0
  name          = var.vsphere_instance_inside_network_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  count         = var.f5xc_vsphere_instance_template != "" ? 1 : 0
  name          = var.f5xc_vsphere_instance_template
  datacenter_id = data.vsphere_datacenter.dc.id
}
