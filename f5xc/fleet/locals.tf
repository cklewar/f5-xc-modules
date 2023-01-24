locals {
  f5xc_tenant = var.is_sensitive ? sensitive(var.f5xc_tenant) : var.f5xc_tenant
}