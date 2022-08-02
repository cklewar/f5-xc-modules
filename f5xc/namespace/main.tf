data "volterra_namespace" "namespace" {
  name = var.f5xc_namespace_name
}

resource "volterra_namespace" "namespace" {
  count = data.volterra_namespace.namespace.id != "" ? 1 : 0
  name = var.f5xc_namespace_name
}