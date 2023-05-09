output "ce" {
  value = {
    id                   = vsphere_virtual_machine.vm.id
    name                 = vsphere_virtual_machine.vm.name
    guest_id             = vsphere_virtual_machine.vm.guest_id
    datastore_id         = vsphere_virtual_machine.vm.datastore_id
    datacenter_id        = vsphere_virtual_machine.vm.datacenter_id
    default_ip_address   = vsphere_virtual_machine.vm.default_ip_address
    guest_ip_addresses   = vsphere_virtual_machine.vm.guest_ip_addresses
    datastore_cluster_id = vsphere_virtual_machine.vm.datastore_cluster_id
  }
}