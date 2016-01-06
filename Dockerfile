FROM ubuntu:14.04.3

ENV VBOX_VERSION 5.0.10
ENV KERNEL_VERSION Ubuntu-4.2.0-16.19
ENV MODULE_DIR /lib/modules/${KERNEL_VERSION}/build

ADD ./create_dir.sh /
RUN apt-get update && apt-get install -y wget curl build-essential p7zip-full && \
    mkdir -p /vboxguest && \
    cd /vboxguest && \
    \
    curl -fL -o vboxguest.iso http://download.virtualbox.org/virtualbox/${VBOX_VERSION}/VBoxGuestAdditions_${VBOX_VERSION}.iso && \
    7z x vboxguest.iso -ir'!VBoxLinuxAdditions.run' && \
    rm vboxguest.iso && \
    \
    sh VBoxLinuxAdditions.run --noexec --target . && \
    mkdir amd64 && tar -C amd64 -xjf VBoxGuestAdditions-amd64.tar.bz2 && \
    rm VBoxGuestAdditions*.tar.bz2

RUN cd /vboxguest && \
    mkdir -p $MODULE_DIR && \
    wget -O -  https://github.com/rancher/os-kernel/releases/download/${KERNEL_VERSION}/build.tar.gz | tar zxf - -C $MODULE_DIR && \
    \
    KERN_DIR=$MODULE_DIR make -C amd64/src/vboxguest-${VBOX_VERSION}

ENTRYPOINT ["/create_dir.sh"]
