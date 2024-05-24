locals {
  node_names = [for id in data.google_compute_instance.instances.*.id :  try(element(split("/", id), length(split("/", id)) - 1), "")]
  #_node_names = [for id in data.google_compute_instance.instances.*.id : split("-", try(element(split("/", id), length(split("/", id)) - 1), ""))]
  #node_names  = [for item in local._node_names : join("-", slice(item, 0, length(item) -1))]
}


