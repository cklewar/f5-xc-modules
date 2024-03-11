resource "terraform_data" "worker" {
  count      = var.worker_nodes_count
  depends_on = [local_file.kubectl_manifest_worker]
  input      = {
    manifest   = "manifest/${var.f5xc_cluster_name}_w${count.index}.yaml"
    kubeconfig = var.f5xc_kubeconfig
    name       = "${var.f5xc_cluster_name}-w${count.index}"
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

resource "local_file" "kubectl_manifest_worker" {
  count   = var.worker_nodes_count
  content = templatefile("${path.module}/templates/rhel9-worker-node-template-static-ip.yaml", {
    cluster-name             = var.f5xc_cluster_name
    host-name                = format("w%d", count.index)
    ip-address               = "10.251.2.${count.index + 10}/16"
    ip-gateway               = "10.251.0.1"
    network                  = count.index % 3 == 0 ? "ves-system/sb-infra-lab-v5-eno5np0-251-vfio" : count.index % 3 == 1 ? "ves-system/sb-infra-lab-v5-eno6np1-251-vfio" : "ves-system/sb-infra-lab-v5-ens1f0np0-251-vfio"
    latitude                 = var.f5xc_cluster_latitude
    longitude                = var.f5xc_cluster_longitude
    maurice-private-endpoint = module.maurice.endpoints.maurice_mtls
    maurice-endpoint         = module.maurice.endpoints.maurice
    site-registration-token  = "596206a6-c5ec-4e40-bbfa-ec412c0e8ef9" #volterra_token.site.id
    certifiedhardware        = var.f5xc_certified_hardware_profile
    f5xc_rhel9_container     = var.f5xc_rhel9_container
  })
  filename = "manifest/${var.f5xc_cluster_name}_w${count.index}.yaml"
}
