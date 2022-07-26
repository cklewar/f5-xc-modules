resource "volterra_virtual_k8s" "vk8s" {
  name      = "ck-vk8s-ams-01"
  namespace = var.f5xc_namespace

  vsite_refs {
    name      = var.f5xc_virtual_site_refs
    namespace = var.f5xc_namespace
  }

  provisioner "local-exec" {
    command = "sleep 120s"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "sleep 30s"
  }
}

resource "volterra_virtual_k8s" "vk8s" {
  name      = "vk8s"
  namespace = var.f5xc_namespace

  vsite_refs {
    name      = "virtual-site"
    namespace = var.f5xc_namespace
  }

  provisioner "local-exec" {
    command = "sleep 120s"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "sleep 30s"
  }

}

resource "local_file" "manifest" {
  content  = local.manifest_content
  filename = format("%s/_output/manifest.yml", path.root)
}

resource "volterra_api_credential" "cred_vk8s" {
  depends_on            = [volterra_virtual_k8s.vk8s]
  name                  = "vk8s-cred"
  api_credential_type   = "KUBE_CONFIG"
  virtual_k8s_namespace = var.f5xc_namespace
  virtual_k8s_name      = volterra_virtual_k8s.vk8s.name
  lifecycle {
    ignore_changes = [name]
  }s
}

resource "local_file" "this_kubeconfig" {
  content  = base64decode(volterra_api_credential.cred_vk8s.data)
  filename = format("%s/_output/ves_cklewar-ns-01_ck-vk8s-ams.yaml", path.root)
}

resource "null_resource" "apply_creds" {
  depends_on = [local_file.this_kubeconfig]
  provisioner "local-exec" {
    command     = format("kubectl create secret docker-registry regcred --docker-server=docker.io --docker-password=Dandy862021 --docker-username=infernotwo --docker-email=cklewar@t-online.de --namespace=%s", var.namespace_ams)
    environment = {
      KUBECONFIG = format("%s/_output/ves_cklewar-ns-01_ck-vk8s-ams.yaml", path.root)
    }
  }
}

resource "null_resource" "apply_manifest" {
  depends_on = [null_resource.apply_creds, local_file.this_kubeconfig, local_file.manifest]
  triggers   = {
    manifest_sha1 = sha1(local.demo_manifest_content_ams)
  }
  provisioner "local-exec" {
    command     = format("kubectl apply -f _output/demo_ams.yml --namespace=%s", var.f5xc_namespace)
    environment = {
      KUBECONFIG = format("%s/_output/ves_cklewar-ns-01_ck-vk8s-ams.yaml", path.root)
    }
  }
  provisioner "local-exec" {
    when        = destroy
    command     = "kubectl delete -f _output/demo.yml --ignore-not-found=true"
    environment = {
      KUBECONFIG = format("%s/_output/ves_cklewar-ns-01_ck-vk8s-ams.yaml", path.root)
    }
    on_failure = continue
  }
}