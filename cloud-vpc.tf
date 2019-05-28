/* Create various services related to networks
   router
   nat
   dns
*/

resource "google_compute_router" "vpc-router" {
  name    = "${google_compute_network.vpc-network.name}-router"
  region  = "${var.region}"
  network = "${google_compute_network.vpc-network.self_link}"
  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "vpc-nat" {
  name                               = "${google_compute_network.vpc-network.name}-nat"
  router                             = "${google_compute_router.vpc-router.name}"
  region                             = "${var.region}"
  nat_ip_allocate_option             = "AUTO_ONLY"
  //nat_ips                            = ["${google_compute_address.vpc-address.self_link}"]
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_dns_managed_zone" "private-zone" {
  name = "private-zone"
  dns_name = "${var.name}.com."
  description = "Example private DNS zone"
  # labels = {
  #   foo = "bar"
  # }

  visibility = "private"

  private_visibility_config {
    networks {
      network_url =  "${google_compute_network.vpc-network.self_link}"
    }
  }
}