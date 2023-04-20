#!/bin/bash
# use the following to clean up resident metadata on disk devices used for OpenShift Data Foundation Installs
# new installations will fail if old data is left resident on disk, in an effort to prevent data loss
# TBD dcain 21-Mar-2023 convert to a Job

set -xv
DISKS=(sdb sdc)

oc project default
# wipe rook directory
for i in $(oc get node -l cluster.ocs.openshift.io/openshift-storage= -o jsonpath='{ .items[*].metadata.name }'); do oc debug node/${i} -- chroot /host rm -rf /var/lib/rook; done

#wipe partition tables
for i in $(oc get node -l cluster.ocs.openshift.io/openshift-storage= -o jsonpath='{ .items[*].metadata.name }');
do
    for disk in ${DISKS[@]}
    do
        oc debug node/${i} -- chroot /host sgdisk --zap-all /dev/$disk
        oc debug node/${i} -- dd if=/dev/zero of=/dev/$disk bs=1M count=100 oflag=direct,dsync
    done
done

oc delete localvolume -n local-storage local-disks --wait=true --timeout=5m
for i in $(oc get node -l cluster.ocs.openshift.io/openshift-storage= -o jsonpath='{ .items[*].metadata.name }'); do oc debug node/${i} -- chroot /host rm -rf /mnt/local-storage/localblock; done
