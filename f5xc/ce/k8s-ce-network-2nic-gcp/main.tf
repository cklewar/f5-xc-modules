resource "google_compute_network" "slo_vpc_network" {
  name                    = "${var.name}-slo-vpc-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_network" "sli_vpc_network" {
  name                    = "${var.name}-sli-vpc-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "slo_subnet" {
  name          = "${var.name}-slo-subnetwork"
  ip_cidr_range = var.fabric_subnet_public
  region        = var.region
  network       = google_compute_network.slo_vpc_network.id
}
resource "google_compute_subnetwork" "sli_subnet" {
  name          = "${var.name}-sli-subnetwork"
  ip_cidr_range = var.fabric_subnet_inside
  region        = var.region
  network       = google_compute_network.sli_vpc_network.id
}

resource "google_compute_firewall" "slo_ingress" {
  name    = "${var.name}-slo-ingress"
  network = google_compute_network.slo_vpc_network.name
  allow {
    protocol = "all"
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "sli_ingress" {
  name    = "${var.name}-sli-ingress"
  network = google_compute_network.sli_vpc_network.name
  allow {
    protocol = "all"
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "slo_egress" {
  name    = "${var.name}-slo-egress"
  network = google_compute_network.slo_vpc_network.name
  allow {
    protocol = "all"
  }
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "sli_egress" {
  name    = "${var.name}-sli-egress"
  network = google_compute_network.sli_vpc_network.name
  allow {
    protocol = "all"
  }
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
}