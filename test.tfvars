/*  Global variables
    project
    region
    zone
    label
*/

name = "test"
project = "projetdemo"
region = "europe-west1"
zone = "europe-west1-b"

label = "test"

/* network variables
   name
*/

network = {
    name = "network"
}


/* subnet variables

*/

client-subnet = {
    name = "admin"
    ip_cidr_range = "192.168.20.0/24"
}

cluster-subnet = {
    name = "editor-cluster"
    ip_cidr_range = "192.168.23.0/24"

    pod-name = "pod-cidr"
    pod-cidr = "10.20.0.0/14"

    service-name = "service-cidr"
    service-cidr = "10.0.96.0/20"
}

/* firewall rules
   ssh from internet
   all ports from client subnet
*/

ssh-rule = "allowssh"

admin-rule = "fulladmin"

/* cluster definition
   name
*/

cluster = {
    name = "cluster"
    master_ipv4_cidr_block = "172.32.255.240/28"
}