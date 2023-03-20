#!/bin/bash

set -x

test -e ${openshift_clustername} || mkdir ${openshift_clustername}


CLIENT_PLATFORM=$(uname -s | tr '[:upper:]' '[:lower:]')
if [[ "$CLIENT_PLATFORM" = "darwin" ]]; then
  CLIENT_PLATFORM=mac
fi


command -v podman > /dev/null || {
  echo podman not found, visit https://podman.io/getting-started/installation and follow install instructions
  exit 1
}

COREOS_INSTALLER="podman run --privileged --pull always --rm -v /dev:/dev -v /run/udev:/run/udev -v $PWD:/data -w /data quay.io/coreos/coreos-installer:release"

cd ${openshift_clustername}
curl -sk https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${openshift_version}/openshift-client-$CLIENT_PLATFORM.tar.gz -o oc.tar.gz
curl -sk https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${openshift_version}/openshift-install-$CLIENT_PLATFORM.tar.gz -o openshift-install.tar.gz

tar xf oc.tar.gz
tar xf openshift-install.tar.gz
rm oc.tar.gz openshift-install.tar.gz

chmod +x oc openshift-install

ISO_URL=$(./openshift-install coreos print-stream-json | grep location | grep ${openshift_architecture} | grep iso | cut -d\" -f4)

curl -sL $ISO_URL -o rhcos-live.iso

cp install-config.yaml backup-install-config.yaml

cd -
./${openshift_clustername}/openshift-install create single-node-ignition-config --dir=${openshift_clustername}

$COREOS_INSTALLER iso ignition embed -fi ${openshift_clustername}/bootstrap-in-place-for-live-iso.ign ${openshift_clustername}/rhcos-live.iso
$COREOS_INSTALLER iso kargs modify -a "ip=${vm_ipaddress}::${vm_gateway}:${vm_netmask}:${openshift_clustername}:${vm_interface}:off ${vm_dns}" ${openshift_clustername}/rhcos-live.iso

