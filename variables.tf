################################################################################
##### vSphere Variables
################################################################################

variable "vsphere_server" {
  type = string
}

variable "vsphere_user" {
  type = string
}

variable "vsphere_password" {
  type = string
}

variable "vsphere_datacenter" {
  type = string
}

variable "vsphere_datastore" {
  type = string
}

variable "vsphere_cluster" {
  type = string
}

variable "vsphere_network" {
  type = string
}

variable "vsphere_folder" {
  type    = string
  default = null
}

variable "vsphere_preexisting_folder" {
  type    = string
  default = false
}

################################################################################
##### OpenShift Variables
################################################################################

variable "openshift_version" {
  type    = string
  default = "latest-4.12"
}

variable "openshift_architecture" {
  type    = string
  default = "x86_64"
}

variable "openshift_clustername" {
  type = string
}

variable "openshift_basedomain" {
  type = string
}

variable "openshift_clusternetwork" {
  type    = string
  default = "10.128.0.0/14"
}

variable "openshift_hostprefix" {
  type    = string
  default = "23"
}

variable "openshift_machinenetwork" {
  type = string
}

variable "openshift_servicenetwork" {
  type    = string
  default = "172.30.0.0/16"
}

variable "openshift_installdisk" {
  type    = string
  default = "/dev/sda"
}

variable "openshift_pullsecret" {
  type = string
}

variable "openshift_sshpublickey" {
  type = string
}

################################################################################
##### VM Variables
################################################################################

variable "vm_ipaddress" {
  type = string
}

variable "vm_netmask" {
  type = string
}

variable "vm_gateway" {
  type = string
}

variable "vm_interface" {
  type    = string
  default = "ens192"
}

variable "vm_dns" {
  type = list(string)
}

variable "vm_cpus" {
  type    = number
  default = 8
}

variable "vm_memory" {
  type    = number
  default = 65536
}

variable "vm_disksize" {
  type    = number
  default = 128
}

