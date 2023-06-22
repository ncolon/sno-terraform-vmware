# Single Node OpenShift (SNO) on VMware

Terraform implementation of a Single Node OpenShift deployment on VMware, with static IP addresses.

## Prereqs

1. [DNS](https://docs.openshift.com/container-platform/4.12/installing/installing_vsphere/installing-vsphere.html#installation-dns-user-infra_installing-vsphere) needs to be configured for external cluster access.
    - api.`openshift_clustername`.`openshift_basedomain` points to `vm_ipaddress`
    - *.apps.`openshift_clustername`.`openshift_basedomain` points to `vm_ipaddress`


## Terraform variables

| Variable                         | Description                                                  | Type   | Default |
| -------------------------------- | ------------------------------------------------------------ | ------ | ------- |
| vsphere_server                   | IP Address or hostname of vSphere server | string | - |
| vsphere_user                     | vSphere username  | string | - |
| vsphere_password                 | vSphere password  | string | - |
| vsphere_datacenter               | vSphere Datacenter where OpenShift will be deployed | string | - |
| vsphere_datastore                | vSphere Datastore for OpenShift nodes  | string | |
| vsphere_cluster                  | vSphere Cluster where OpenShift will be deployed  | string | - |
| vsphere_network                  | vSphere Network for OpenShift nodes  | string | - |
| vsphere_folder                   | The relative path to the folder which should be used or created for VMs. | string | - |
| vsphere_preexisting_folder       | If false, creates a top-level folder with the name from vsphere_folder. | bool | false |
| openshift_version                | OpenShift version to install | string | latest-4.12 |
| openshift_architecture           | OpenShift architecture | string | x86_64 |
| openshift_clustername            | OpenShift cluster name | string | - |
| openshift_basedomain             | OpenShift cluster base domain | string | - |
| openshift_clusternetwork         | CIDR for OpenShift pod network | string | 10.128.0.0/14 |
| openshift_hostprefix             | OpenShift host prefix | string | 23 |
| openshift_machinenetwork         | CIDR where vSphere VMs will be deployed into | string | - |
| openshift_servicenetwork         | CIDR for OpenShift services network | string | 172.30.0.0/16 |
| openshift_installdisk            | Target disk where OpenShift will be installed on the VMware VM| string | /dev/sda |
| openshift_pullsecret             | Your OpenShift [pull secret](https://cloud.redhat.com/openshift/install/vsphere/user-provisioned)| string | - |
| openshift_sshpublickey           | Contents of your ssh public key.  If left blank, the script will generate one for you | string | - |
| vm_ipaddress                     | IP Address for your SNO vm | string | - |
| vm_netmask                       | Network mask for your SNO vm | string | - |
| vm_gateway                       | Network gateway for your SNO vm | string | - |
| vm_interface                     | Network interface for your SNO vm | string | ens192 |
| vm_dns                           | IP Addresses for your DNS servers| list | - |
| vm_cpus                          | Number of CPUs required for your SNO vm| number | 8 |
| vm_memory                        | Memory required for your SNO vm in MB | number | 65536 |
| vm_disksize                      | Disk size required for your SNO vm in GB | number | 128 |


## Sample terraform vars file

```tfvars
vsphere_server     = "9.42.67.251"
vsphere_user       = "administrator@vsphere.local"
vsphere_password   = "xxxxxxxxxxxxxxxx"
vsphere_datacenter = "dc01"
vsphere_cluster    = "cluster01"
vsphere_datastore  = "openshift"
vsphere_network    = "vDPortGroup"
vsphere_folder     = "sno"


openshift_clustername    = "c1"
openshift_basedomain     = "rtp.raleigh.ibm.com"
openshift_machinenetwork = "9.42.67.128/25"
openshift_pullsecret     = "{'auths': { . . . }}"
openshift_sshpublickey   = "ssh-rsa AAAAB . . ."

vm_ipaddress = "9.42.67.141"
vm_netmask   = "255.255.255.128"
vm_gateway   = "9.42.67.129"
vm_interface = "ens192"
vm_dns = [
  "9.42.106.2",
  "9.42.106.3"
]
vm_cpus     = 8
vm_memory   = 65536
vm_disksize = 128
```
