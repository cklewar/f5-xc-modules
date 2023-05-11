locals {
  node_names = [for id in data.google_compute_instance.instances.*.id :  try(element(split("/", id), length(split("/", id)) - 1), "")]
}