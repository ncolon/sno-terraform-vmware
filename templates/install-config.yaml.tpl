apiVersion: v1
baseDomain: ${openshift_basedomain}
compute:
- name: worker
  replicas: 0 
controlPlane:
  name: master
  replicas: 1 
metadata:
  name: ${openshift_clustername}
networking: 
  clusterNetwork:
  - cidr: ${openshift_clusternetwork}
    hostPrefix: ${openshift_hostprefix}
  machineNetwork:
  - cidr: ${openshift_machinenetwork}
  networkType: OVNKubernetes
  serviceNetwork:
  - ${openshift_servicenetwork}
platform:
  none: {}
bootstrapInPlace:
  installationDisk: ${openshift_installdisk}
pullSecret: '${openshift_pullsecret}'
sshKey: |
  ${openshift_sshpublickey}