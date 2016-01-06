#!/bin/bash

VM=${1}
id=$(id -u $(whoami))
gid=$(id -g $(whoami))

docker build --rm -t vboxguest-base .

docker-machine ssh ${VM} mkdir -p /home/docker/vbox
docker run -it -v /home/docker/vbox/:/target vboxguest-base
docker-machine scp -r ${VM}:/home/docker/vbox ./

docker build --rm -f Dockerfile.dist -t cloudnautique/vboxguest .
docker run -it --privileged \
    -v /lib/modules:/lib/modules \
    -v /sbin/:/target/sbin \
    cloudnautique/vboxguest

docker-machine ssh ${VM} sudo mkdir -p /Users
docker-machine ssh ${VM} sudo /sbin/mount.vboxsf -o rw,uid=${id},gid=${gid} Users /Users
