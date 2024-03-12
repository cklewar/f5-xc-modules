resource "terraform_data" "master" {
  count = var.master_nodes_count
  input = {
    name                 = "${var.f5xc_cluster_name}-m${count.index}"
    manifest             = local.master_vmi_manifest[count.index]
    kubeconfig           = module.kubeconfig_infrastructure.config
    kubeconfig_file      = module.kubeconfig_infrastructure.filename
    kubeconfig_file_name = basename(module.kubeconfig_infrastructure.filename)
  }

  provisioner "local-exec" {
    command     = <<EOT
kubectl apply -f - --kubeconfig ${self.input.kubeconfig_file} <<EOF
${self.input.manifest}
EOF
EOT
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    command     = "sleep 3"
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    command     = "kubectl wait --for=condition=ready pod -l vm.kubevirt.io/name=${self.input.name} --kubeconfig ${self.input.kubeconfig_file}"
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    command     = "sleep 3"
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    command     = "kubectl wait --for=condition=Ready vmis/${self.input.name} --kubeconfig ${self.input.kubeconfig_file}"
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = <<EOT
cat > ${self.input.kubeconfig_file_name} <<EOF
${self.input.kubeconfig}
EOF
EOT
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = <<EOT
kubectl delete -f - --kubeconfig ${self.input.kubeconfig_file_name} <<EOF
${self.input.manifest}
EOF
EOT
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }
}

resource "terraform_data" "master_cordon" {
  depends_on = [terraform_data.master]
  count      = var.master_nodes_count
  input      = {
    name            = "${var.f5xc_cluster_name}-m${count.index}"
    manifest        = "${abspath(path.module)}/manifest/${var.f5xc_cluster_name}_m${count.index}.yaml"
    kubeconfig_file = module.kubeconfig_testbed.filename
  }

  provisioner "local-exec" {
    command     = "sleep 120"
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    command     = "kubectl cordon ${self.input.name} --kubeconfig ${self.input.kubeconfig_file}"
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }
}

resource "terraform_data" "worker" {
  count = var.worker_nodes_count
  input = {
    name                 = "${var.f5xc_cluster_name}-w${count.index}"
    manifest             = local.worker_vmi_manifest[count.index]
    kubeconfig           = module.kubeconfig_infrastructure.config
    kubeconfig_file      = module.kubeconfig_infrastructure.filename
    kubeconfig_file_name = basename(module.kubeconfig_infrastructure.filename)
  }

  provisioner "local-exec" {
    command     = <<EOT
kubectl apply -f - --kubeconfig ${self.input.kubeconfig_file} <<EOF
${self.input.manifest}
EOF
EOT
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    command     = "sleep 3"
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    command     = "kubectl wait --for=condition=ready pod -l vm.kubevirt.io/name=${self.input.name} --kubeconfig ${self.input.kubeconfig_file}"
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    command     = "sleep 3"
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    command     = "kubectl wait --for=condition=Ready vmis/${self.input.name} --kubeconfig ${self.input.kubeconfig_file}"
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = <<EOT
cat > ${self.input.kubeconfig_file_name} <<EOF
${self.input.kubeconfig}
EOF
EOT
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = <<EOT
kubectl delete -f - --kubeconfig ${self.input.kubeconfig_file_name} <<EOF
${self.input.manifest}
EOF
EOT
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }
}