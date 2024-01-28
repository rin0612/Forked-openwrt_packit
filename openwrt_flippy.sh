#!/bin/bash

echo "package by openwrt_sswdr.backup.2022.04.25.sh"

sudo apt-get update && sudo apt-get install -y p7zip p7zip-full zip unzip gzip xz-utils pigz zstd
git clone ${PACKIT_REPO_URL} -b ${PACKIT_REPO_BRANCH} /opt/openwrt_packit
cd /opt/openwrt_packit
wget -q ${OPENWRT_ARMVIRT}

mkdir kernel && cd kernel
wget -q -O kernel.tar.gz ${KERNEL_REPO_URL}/${KERNEL_VERSION}.tar.gz
tar -zxvf kernel.tar.gz && rm kernel.tar.gz

cd /opt/openwrt_packit
echo "WHOAMI=\"${WHOAMI}\"" >> make.env
echo "KERNEL_VERSION=\"${KERNEL_VERSION_NAME}\"" >> make.env
echo "KERNEL_PKG_HOME=\"/opt/openwrt_packit/kernel\"" >> make.env
echo "OPENWRT_VER=\"${OPENWRT_VER}\"" >> make.env

sudo ./${RUN_SH}

