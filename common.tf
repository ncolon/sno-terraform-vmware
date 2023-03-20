data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = local.vsphere_datacenter_id
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = local.vsphere_datacenter_id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = local.vsphere_datacenter_id
}

data "vsphere_folder" "folder" {
  count = var.vsphere_preexisting_folder ? 1 : 0
  path  = "${var.vsphere_datacenter}/vm/${var.vsphere_folder}"
}

resource "vsphere_folder" "folder" {
  count         = var.vsphere_preexisting_folder ? 0 : 1
  path          = var.vsphere_folder
  type          = "vm"
  datacenter_id = local.vsphere_datacenter_id
}


locals {
  vsphere_datacenter_id = data.vsphere_datacenter.datacenter.id
  vsphere_cluster_id    = data.vsphere_compute_cluster.cluster.id
  vsphere_datastore_id  = data.vsphere_datastore.datastore.id
  vsphere_network_id    = data.vsphere_network.network.id
  vsphere_folder_path   = var.vsphere_preexisting_folder ? data.vsphere_folder.folder[0].path : vsphere_folder.folder[0].path
}

