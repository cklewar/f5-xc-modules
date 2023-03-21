resource "azurerm_marketplace_agreement" "volterra" {
  count     = var.machine_image == "" ? 1 : 0
  publisher = var.ce_image_publisher
  offer     = var.ce_image_offer
  plan      = var.ce_image_name
}