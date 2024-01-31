resource "restapi_object" "secure_mesh_site" {
  path         = "/config/namespaces/system/securemesh_sites"
  data         = local.secure_mesh_site_data.json
  id_attribute = "metadata/name"
}