

resource "google_container_cluster" "editor-cluster" {
  name = "${var.name}-${var.cluster["name"]}-${var.label}"
  zone = "${var.zone}"
  min_master_version = "1.11.8-gke.6"
  initial_node_count = 2
  remove_default_node_pool = true

/* Define additional zones if needed
  additional_zones = [
    "us-central1-b",
    "us-central1-c",
  ]
*/

/* Network config
   network
   subnetwork
   ip allocation policy
*/

  network = "${google_compute_network.vpc-network.self_link}"
  subnetwork = "${google_compute_subnetwork.cluster-subnet.self_link}"
  
  ip_allocation_policy {
    cluster_secondary_range_name = "${var.cluster-subnet["name"]}-${var.cluster-subnet["pod-name"]}"
    services_secondary_range_name = "${var.cluster-subnet["name"]}-${var.cluster-subnet["service-name"]}"
  }

/* Master configuration
   authorized networks

*/

  master_authorized_networks_config {
   cidr_blocks = [
      /*
      {
        cidr_block   = "${var.editor-subnet["ip_cidr_range"]}"
        display_name = "access-users"
      },*/
      {
        cidr_block   = "${var.client-subnet["ip_cidr_range"]}"
        display_name = "access-client"
      },
    ]
  }

  master_auth {
    username = ""
    password = ""
  }

/* Cluster config
   private options
   pod security
   network policy
   addons
*/

  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes = true
    master_ipv4_cidr_block = "${var.cluster["master_ipv4_cidr_block"]}"
  }


  network_policy {
    enabled = true
  }

// GKE addons
  addons_config {
  http_load_balancing {
    disabled = true
  }
  horizontal_pod_autoscaling {
    disabled = false
  }

  network_policy_config {
    disabled = false
  }
  
}


/*
    tags = ["foo", "bar"]
*/
}

resource "google_container_node_pool" "stateful-np" {
  name       = "stateful-nodepool"
  zone = "${var.zone}"
  cluster    = "${google_container_cluster.editor-cluster.name}"
  node_count = 1

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append"
    ]

    // Machine type with 10 vCPUs and 50GB of RAM (50*1024Mo=51200)
    machine_type = "n1-standard-1"

    // Disk size of 128 GB
    disk_size_gb = "10"

    // Disk type ssd
    disk_type = "pd-ssd"

    service_account = ""
    
    labels {
      environment = "${var.label}"
      editor = "sateful"
    }

    tags = ["editor-nodes"]
  }
}
resource "google_container_node_pool" "stateless-np" {
  name       = "stateless-nodepool"
  zone = "${var.zone}"
  cluster    = "${google_container_cluster.editor-cluster.name}"
  node_count = 1

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append"
    ]

    // Machine type with 10 vCPUs and 50GB of RAM (50*1024Mo=51200)
    machine_type = "n1-standard-1"

    // Disk size of 128 GB
    disk_size_gb = "10"

    // Disk type ssd
    disk_type = "pd-ssd"

    service_account = ""
    
    labels {
      environment = "${var.label}"
      editor = "sateful"
    }

    tags = ["editor-nodes"]
  }
}
/* available following options
disk_size_gb 
disk_type
guest_accelerator
image_type
labels
local_ssd_count
machine_type
metadata
min_cpu_platform
oauth_scopes
preemptible
service_account
tags
taint
workload_metadata_config
*/

output "client_certificate" {
  value = "${google_container_cluster.editor-cluster.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.editor-cluster.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.editor-cluster.master_auth.0.cluster_ca_certificate}"
}
