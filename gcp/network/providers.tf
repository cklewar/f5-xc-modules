provider "google" {
  credentials = var.gcp_credentials_file_path != "" ? file(var.gcp_credentials_file_path) : var.gcp_google_credentials
  project     = var.gcp_project_name
  region      = var.gcp_region
  zone        = var.gcp_zone
}