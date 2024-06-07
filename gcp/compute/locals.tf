locals {
  cloud_init_content = var.gcp_compute_instance_cloud_init_template != "" ? templatefile(format("%s/%s", var.template_input_dir_path, var.gcp_compute_instance_cloud_init_template), var.gcp_compute_instance_cloud_init_template_data) : ""
}