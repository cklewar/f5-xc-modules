resource "null_resource" "check_nfv_online" {
  triggers = {
    always = local.random_id
  }

  provisioner "local-exec" {
    command     = format("%s/scripts/check.sh https://%s.%s", path.module, var.f5xc_nfv_node_name, var.f5xc_nfv_domain_suffix)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }
}