provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

resource "tls_private_key" "installkey" {
  count = var.openshift_sshpublickey == "" ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "local_file" "install_config_yaml" {
  content = templatefile("${path.root}/templates/install-config.yaml.tpl", {
    openshift_basedomain     = var.openshift_basedomain
    openshift_clustername    = var.openshift_clustername
    openshift_clusternetwork = var.openshift_clusternetwork
    openshift_hostprefix     = var.openshift_hostprefix
    openshift_machinenetwork = var.openshift_machinenetwork
    openshift_servicenetwork = var.openshift_servicenetwork
    openshift_installdisk    = var.openshift_installdisk
    openshift_pullsecret     = replace(var.openshift_pullsecret, "'", "\"")
    openshift_sshpublickey   = var.openshift_sshpublickey == "" ? chomp(tls_private_key.installkey[0].public_key_openssh) : chomp(var.openshift_sshpublickey)
  })
  filename = "${var.openshift_clustername}/install-config.yaml"
}


resource "null_resource" "create_iso" {
  triggers = {
    openshift_clustername = var.openshift_clustername
  }

  depends_on = [
    local_file.install_config_yaml
  ]
  provisioner "local-exec" {
    when = create
    command = templatefile("${path.root}/templates/create-iso.sh.tpl", {
      openshift_version      = var.openshift_version
      openshift_architecture = var.openshift_architecture
      openshift_clustername  = var.openshift_clustername
      vm_ipaddress           = var.vm_ipaddress
      vm_gateway             = var.vm_gateway
      vm_netmask             = var.vm_netmask
      vm_interface           = var.vm_interface
      vm_dns                 = join(" ", formatlist("nameserver=%v", var.vm_dns))
    })
    interpreter = ["bash", "-c"]
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf ${self.triggers.openshift_clustername}"
  }

}

resource "vsphere_file" "iso" {
  depends_on = [
    null_resource.create_iso
  ]
  datacenter         = var.vsphere_datacenter
  datastore          = var.vsphere_datastore
  source_file        = "${var.openshift_clustername}/rhcos-live.iso"
  destination_file   = "images/${var.openshift_clustername}.iso"
  create_directories = true
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.openshift_clustername
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = local.vsphere_datastore_id
  num_cpus         = var.vm_cpus
  memory           = var.vm_memory
  guest_id         = "otherGuest64"
  network_interface {
    network_id = local.vsphere_network_id
  }
  disk {
    label = "disk0"
    size  = var.vm_disksize
  }
  folder = local.vsphere_folder_path
  cdrom {
    datastore_id = local.vsphere_datastore_id
    path         = vsphere_file.iso.destination_file
  }
}

resource "null_resource" "wait" {
  triggers = {
    openshift_clustername = var.openshift_clustername
  }

  depends_on = [
    vsphere_virtual_machine.vm
  ]
  provisioner "local-exec" {
    when    = create
    command = "${self.triggers.openshift_clustername}/openshift-install wait-for install-complete --dir=${self.triggers.openshift_clustername} --log-level=debug"
  }
}

