/*  General scope variables
    name
    project
    region
    zone
*/


variable "name" {
    type = "string"
    default = "test"
}
variable "project" {
    type = "string"
}
variable "region" {
    type= "string"
    default = "europe-west1"
}

variable "zone" {
    type = "string"
    default = "europe-west1-b"
}

variable "label" {
    type = "string"
    default = "test"
}

/* network variables
   name
*/
variable "network" {
    type = "map"
}

/* subnets variables
   name
*/

variable  "cluster-subnet" {
    type = "map"
}

variable  "client-subnet" {
    type = "map"
}
/* firewall rules
   ssh
*/
variable "ssh-rule" {
    type = "string"
    default = "allowssh"
}

variable "admin-rule" {
    type = "string"
    default = "allowadmin"
}

/* cluster variable
    name
*/

variable "cluster" {
    type = "map"
}