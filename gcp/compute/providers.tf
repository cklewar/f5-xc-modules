provider "google" {
  credentials = file(var.gcp_credentials_file_path)
  project     = var.gcp_project_name
  region      = var.gcp_region
  zone        = var.gcp_zone
}