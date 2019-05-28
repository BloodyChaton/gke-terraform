/*  General resources
    project metadata
    network
*/

// Generate global authorized keys over the project instances
/*
resource "google_compute_project_metadata" "adminers" {
  metadata {
    ssh-keys  = "user-name:${file("path-to-public-key")}"
  }
}
*/

// Create the sole VPC network to be peered to the clusters
resource "google_compute_network" "vpc-network" {
  name                    = "${var.name}-${var.network["name"]}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "cluster-subnet" {
  name          = "${var.name}-subnetwork-${var.cluster-subnet["name"]}"
  ip_cidr_range = "${var.cluster-subnet["ip_cidr_range"]}"
  region        = "${var.region}"
  network       = "${google_compute_network.vpc-network.self_link}"

  secondary_ip_range {
    range_name    = "${var.cluster-subnet["name"]}-${var.cluster-subnet["pod-name"]}"
    ip_cidr_range = "${var.cluster-subnet["pod-cidr"]}"
  }
  secondary_ip_range {
    range_name    = "${var.cluster-subnet["name"]}-${var.cluster-subnet["service-name"]}"
    ip_cidr_range = "${var.cluster-subnet["service-cidr"]}"
  }
}

resource "google_compute_subnetwork" "client-subnet" {
  name          = "${var.name}-subnetwork-${var.client-subnet["name"]}"
  ip_cidr_range = "${var.client-subnet["ip_cidr_range"]}"
  region        = "${var.region}"
  network       = "${google_compute_network.vpc-network.self_link}"
}

resource "google_compute_firewall" "ssh-rule" {
  name    = "${google_compute_network.vpc-network.name}-${var.ssh-rule}-rule"
  network = "${google_compute_network.vpc-network.name}"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["${var.ssh-rule}"]
}

/* Create the ingress rule from the admin-subnet
   to target any ip/port on the vpc-network
*/
resource "google_compute_firewall" "fulladmin" {
  name    = "${google_compute_network.vpc-network.name}-${var.admin-rule}-rule"
  network = "${google_compute_network.vpc-network.name}"
  direction = "INGRESS"

  priority = 1
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  source_ranges = ["${var.client-subnet["ip_cidr_range"]}"]

}