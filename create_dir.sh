#!/bin/bash 

if [ ! -d /vboxguest ]; then
    echo "No vboxguest additions"
    exit 1
fi

if [ ! -d /target ]; then
    mkdir -p /target
fi

mkdir -p /target/{sbin,lib/modules}
cp /vboxguest/amd64/src/vboxguest-${VBOX_VERSION}/*.ko /target/lib/modules/
cp /vboxguest/amd64/lib/VBoxGuestAdditions/mount.vboxsf /target/sbin/
