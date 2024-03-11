resource "local_file" "kubectl_manifest_master" {
  count   = var.master_nodes_count
  content = templatefile("${path.module}/templates/rhel9-master-node-template-static-ip.yaml", {
    network                    = count.index % 3 == 0 ? "ves-system/sb-infra-lab-v5-eno5np0-251-vfio" : count.index % 3 == 1 ? "ves-system/sb-infra-lab-v5-eno6np1-251-vfio" : "ves-system/sb-infra-lab-v5-ens1f0np0-251-vfio"
    latitude                   = var.f5xc_cluster_latitude
    longitude                  = var.f5xc_cluster_longitude
    host_name                  = format("m%d", count.index)
    ip_address                 = "10.251.1.${count.index + 10}/16"
    ip_gateway                 = "10.251.0.1"
    cluster_name               = var.f5xc_cluster_name
    maurice_endpoint           = module.maurice.endpoints.maurice
    f5xc_rhel9_container       = var.f5xc_rhel9_container
    site_registration_token    = "596206a6-c5ec-4e40-bbfa-ec412c0e8ef9" #volterra_token.site.id
    maurice_private_endpoint   = module.maurice.endpoints.maurice_mtls
    certified_hardware_profile = var.f5xc_certified_hardware_profile
  })
  filename = "manifest/${var.f5xc_cluster_name}_m${count.index}.yaml"
}

resource "terraform_data" "master" {
  count      = var.master_nodes_count
  depends_on = [local_file.kubectl_manifest_master]
  input      = {
    manifest   = "manifest/${var.f5xc_cluster_name}_m${count.index}.yaml"
    kubeconfig = var.f5xc_kubeconfig
    name       = "${var.f5xc_cluster_name}-m${count.index}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${self.input.manifest} --kubeconfig ${self.input.kubeconfig} && kubectl wait --for=condition=ready pod -l vm.kubevirt.io/name=${self.input.name} --kubeconfig ${self.input.kubeconfig}"
  }
  provisioner "local-exec" {
    when       = destroy
    on_failure = continue
    command    = "kubectl delete -f ${self.input.manifest} --kubeconfig ${self.input.kubeconfig}"
  }
}