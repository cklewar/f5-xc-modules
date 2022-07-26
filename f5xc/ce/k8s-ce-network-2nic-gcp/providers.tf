provider "google" {
  credentials = file(var.credentials_file_path)
  project     = var.project_name
  region      = var.region
  zone        = var.zone
}