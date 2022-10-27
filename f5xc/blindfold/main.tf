resource "null_resource" "create_secret_policy_rule" {
  triggers = {
    manifest_sha1 = sha1(local.f5xc_blindfold_policy_rule_payload)
    api_url       = var.f5xc_api_url
    api_token     = var.f5xc_api_token
    namespace     = var.f5xc_namespace
  }

  provisioner "local-exec" {
    command     = format("curl -v -X 'POST' '%s/%s' -H 'Content-Type: application/json' -H 'Authorization: APIToken %s' -d '%s'", var.f5xc_api_url, local., var.f5xc_api_token, local.f5xc_blindfold_policy_rule_payload)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "${path.module}/scripts/delete.sh"
    on_failure  = fail
    environment = {
      api_token = self.triggers.api_token
      api_url   = self.triggers.api_url
      namespace = self.triggers.namespace
    }
  }
}

resource "null_resource" "create_secret_policys" {
  depends_on = [null_resource.create_secret_policy_rule]
  triggers   = {
    manifest_sha1 = sha1(local.f5xc_blindfold_policys_payload)
    api_url       = var.f5xc_api_url
    api_token     = var.f5xc_api_token
    namespace     = var.f5xc_namespace
  }

  provisioner "local-exec" {
    command     = format("curl -v -X 'POST' '%s/%s' -H 'Content-Type: application/json' -H 'Authorization: APIToken %s' -d '%s'", var.f5xc_api_url, var.f5xc_uri_secret_management_secret_policys, var.f5xc_api_token, local.f5xc_blindfold_policys_payload)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "${path.module}/scripts/delete.sh"
    on_failure  = fail
    environment = {
      api_token = self.triggers.api_token
      api_url   = self.triggers.api_url
      namespace = self.triggers.namespace
    }
  }
}

/*vesctl \
      --cert file:///$HOME/.ves-internal/demo1/usercerts.crt \
      --key file:///$HOME/.ves-internal/demo1/usercerts.key \
      --cacert file:///$HOME/.ves-internal/demo1/cacerts/public_server_ca.crt  \
      --server-urls https://ves-io.demo1.volterra.us/api \
      request secrets get-policy-document --namespace system --name ver-secret-policy

      curl -X 'GET' \
  'https://playground.staging.volterra.us/api/secret_management/namespaces/system/secret_policys/site-secret-policy/get_policy_document' \
  -H 'accept: application/json' \
  -H 'Access-Control-Allow-Origin: *' \
  -H 'Authorization: APIToken LhqZ7DZgLxNk3ib/DUydAc+8JPQ=' \
  -H 'x-volterra-apigw-tenant: playground'
*/

data "http" "policy_document" {
  depends_on = [null_resource.create_secret_policy_rule, null_resource.create_secret_policys]
  url        = format("%s/%s", var.f5xc_api_url, var.f5xc_uri_secret_management_secret_policys_policy_document)

  request_headers = {
    Authorization           = format("APIToken %s", var.f5xc_api_token)
    Accept                  = "application/json"
    x-volterra-apigw-tenant = var.f5xc_namespace
  }
}

/*resource "null_resource" "get_policy_document" {
  depends_on = [null_resource.create_secret_policy_rule]
  triggers   = {
    manifest_sha1 = sha1(local.f5xc_blindfold_policys_payload)
    api_url       = var.f5xc_api_url
    api_token     = var.f5xc_api_token
    namespace     = var.f5xc_namespace
  }

  provisioner "local-exec" {
    command     = format("curl -v -X 'POST' '%s/%s' -H 'Content-Type: application/json' -H 'Authorization: APIToken %s' -d '%s'", var.f5xc_api_url, var.f5xc_uri_secret_management_secret_policys, var.f5xc_api_token, local.f5xc_blindfold_policys_payload)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "${path.module}/scripts/delete.sh"
    on_failure  = fail
    environment = {
      api_token = self.triggers.api_token
      api_url   = self.triggers.api_url
      namespace = self.triggers.namespace
    }
  }
}*/

/*vesctl \
      --cert file:///<absolute_path_to_crt> \
      --key file:///<absolute_path_to_key> \
      --cacert file:///<absolute_path_to_truststore> \
      --server-urls https://ves-io.demo1.volterra.us/api \
      request secrets get-public-key

      curl -X 'GET' \
  'https://playground.staging.volterra.us/api/secret_management/get_public_key?key_version=0' \
  -H 'accept: application/json' \
  -H 'Access-Control-Allow-Origin: *' \
  -H 'Authorization: APIToken LhqZ7DZgLxNk3ib/DUydAc+8JPQ=' \
  -H 'x-volterra-apigw-tenant: playground'
*/

data "http" "public_key" {
  depends_on = [null_resource.create_secret_policy_rule, null_resource.create_secret_policys]
  url        = format("%s/%s", var.f5xc_api_url, var.f5xc_uri_secret_management_public_key)

  request_headers = {
    Authorization           = format("APIToken %s", var.f5xc_api_token)
    Accept                  = "application/json"
    x-volterra-apigw-tenant = var.f5xc_namespace
  }
}

/*resource "null_resource" "get_public_key" {
  depends_on = [null_resource.create_secret_policy_rule]
  triggers   = {
    manifest_sha1 = sha1(local.f5xc_blindfold_policys_payload)
    api_url       = var.f5xc_api_url
    api_token     = var.f5xc_api_token
    namespace     = var.f5xc_namespace
  }

  provisioner "local-exec" {
    command     = format("curl -v -X 'POST' '%s/%s' -H 'Content-Type: application/json' -H 'Authorization: APIToken %s' -d '%s'", var.f5xc_api_url, var.f5xc_uri_secret_management_secret_policys, var.f5xc_api_token, local.f5xc_blindfold_policys_payload)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "${path.module}/scripts/delete.sh"
    on_failure  = fail
    environment = {
      api_token  = self.triggers.api_token
      api_url    = self.triggers.api_url
      namespace  = self.triggers.namespace
    }
  }
}*/

/*
./vesctl request secrets encrypt \
        --policy-document <path to Policy Doc file>
        --public-key <path to Key Parameters Doc file> \
        <path to secret file>
*/

resource "null_resource" "secrets_encrypt" {
  depends_on = [null_resource.create_secret_policy_rule]
  triggers   = {
    manifest_sha1 = sha1(local.f5xc_blindfold_policys_payload)
    api_url       = var.f5xc_api_url
    api_token     = var.f5xc_api_token
    namespace     = var.f5xc_namespace
  }

  provisioner "local-exec" {
    command     = format("curl -v -X 'POST' '%s/%s' -H 'Content-Type: application/json' -H 'Authorization: APIToken %s' -d '%s'", var.f5xc_api_url, var.f5xc_uri_secret_management_secret_policys, var.f5xc_api_token, local.f5xc_blindfold_policys_payload)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }
}