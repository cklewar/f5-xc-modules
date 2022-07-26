provider "bigip" {
  address  = format("%s.%s", var.nfv_node_name, var.nfv_domain_suffix)
  username = var.bigip_admin_username
  // fix this to be integrated with Blindfold
  password = var.bigip_admin_password
}