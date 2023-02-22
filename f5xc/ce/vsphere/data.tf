data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "ds" {
  for_each         = {for k,v in var.nodes: k => v}
  name          = each.value.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host" {
  for_each         = {for k,v in var.nodes: k => v}
  name          = each.value.host
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "outside" {
  name          = var.outside_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "inside" {
  name          = var.inside_network == "" ? var.outside_network : var.inside_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

