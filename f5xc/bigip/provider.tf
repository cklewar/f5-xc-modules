provider "bigip" {
  address  = var.bigip_address
  username = var.bigip_admin_username
  // fix me to be integrated with Blindfold
  password = var.bigip_admin_password
}