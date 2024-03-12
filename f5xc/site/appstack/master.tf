resource "local_file" "kubectl_manifest_master" {
  count   = var.master_nodes_count
  content = templatefile("${path.module}/templates/${var.master_node_manifest_template}.yaml", {
    network                    = count.index % 2 == 0 ? "ves-system/sb-infra-lab-v5-eno5np0-251-vfio" : "ves-system/sb-infra-lab-v5-eno6np1-251-vfio"
    latitude                   = var.f5xc_cluster_latitude
    longitude                  = var.f5xc_cluster_longitude
    host_name                  = format("m%d", count.index)
    ip_address                 = "${var.master_node_ip_address_prefix}${count.index + 10}/${var.master_node_ip_address_suffix}"
    ip_gateway                 = var.ip_gateway
    cluster_name               = var.f5xc_cluster_name
    maurice_endpoint           = module.maurice.endpoints.maurice
    master_node_cpus           = var.master_node_cpus
    master_node_memory         = var.master_node_memory
    f5xc_rhel9_container       = var.f5xc_rhel9_container
    site_registration_token    = var.site_registration_token != "" ? var.site_registration_token : volterra_token.token.id
    maurice_private_endpoint   = module.maurice.endpoints.maurice_mtls
    certified_hardware_profile = var.f5xc_certified_hardware_profile
  })
  filename = "${abspath(path.module)}/manifest/${var.f5xc_cluster_name}_m${count.index}.yaml"
}

resource "terraform_data" "master" {
  depends_on = [local_file.kubectl_manifest_master]
  count      = var.master_nodes_count
  input      = {
    name                 = "${var.f5xc_cluster_name}-m${count.index}"
    manifest             = "${abspath(path.module)}/manifest/${var.f5xc_cluster_name}_m${count.index}.yaml"
    kubeconfig           = module.kubeconfig_infrastructure.config
    kubeconfig_file      = module.kubeconfig_infrastructure.filename
    kubeconfig_file_name = basename(module.kubeconfig_infrastructure.filename)
  }

  provisioner "local-exec" {
    command     = <<EOT
cat ${self.input.manifest}
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
    command = "kubectl cordon ${self.input.name} --kubeconfig ${self.input.kubeconfig_file}"
  }
}