resource "google_compute_instance" "client" {
  name         = "${var.name}-client"
  machine_type = "n1-standard-1"
  zone         = "${var.zone}"

  tags = ["allowssh"]

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
    auto_delete = true
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.client-subnet.self_link}"

    access_config {
      // Ephemeral IP
    }
  }

  metadata {
    ssh-keys = "kubeclient:${file("~/.ssh/id_rsa-wunderit.pub")}"
  }

  // metadata_startup_script = "${file("startup.sh")}"

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}