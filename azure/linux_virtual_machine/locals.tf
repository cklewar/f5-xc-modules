locals {
  cloud_init_content = var.azure_virtual_machine_cloud_init_template != "" ? templatefile(format("%s/%s", var.template_input_dir_path, var.azure_virtual_machine_cloud_init_template), var.azure_virtual_machine_cloud_init_template_data) : ""
}