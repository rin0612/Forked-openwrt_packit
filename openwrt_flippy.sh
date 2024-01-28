#!/bin/bash

echo "package by openwrt_sswdr.backup.2022.04.25.sh"

sudo apt-get update && sudo apt-get install -y p7zip p7zip-full zip unzip gzip xz-utils pigz zstd
git clone https://github.com/rin0612/openwrt_packit -b backup.2022.04.25 /opt/openwrt_packit
cd /opt/openwrt_packit
wget -q ${OPENWRT_ARMVIRT}

mkdir kernel && cd kernel
# wget -q -O kernel.tar.gz https://github.com/rin0612/openwrt_packit/releases/download/backup.kernel/5.10.110.tar.gz
wget -q -O kernel.tar.gz ${KERNEL_REPO_URL}/${KERNEL_VERSION}.tar.gz
tar -zxvf kernel.tar.gz && rm kernel.tar.gz

cd /opt/openwrt_packit
cat << EOF >> make.env
WHOAMI="${WHOAMI}"
KERNEL_VERSION="{KERNEL_VERSION_NAME}"
KERNEL_PKG_HOME="/opt/openwrt_packit/kernel"
OPENWRT_VER="{OPENWRT_VER}"
EOF

sudo ./${RUN_SH}
