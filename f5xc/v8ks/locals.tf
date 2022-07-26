locals {
  manifest_content = templatefile(format("%s/manifest/manifest.tpl", path.module), {
    namespace = var.f5xc_namespace
  })
}
