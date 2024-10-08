locals {
  algorithm = jsondecode(base64decode(split(".", restful_resource.token.output.spec.content)[0])).alg
}