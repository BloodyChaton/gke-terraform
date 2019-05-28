# providers info
provider "google" {
  // please provide your credentials as an sa.json file
  credentials = "${file("sa.json")}"
  project     = "${var.project}"
  region  = "${var.region}"
  zone    = "${var.zone}"
}