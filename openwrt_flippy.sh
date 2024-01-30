#!/bin/bash

echo "------ package by openwrt_sswdr.backup.2022.04.25.sh"

sudo apt-get update && sudo apt-get install -y p7zip p7zip-full zip unzip gzip xz-utils pigz zstd
echo "------ 准备打包仓库: git clone ${PACKIT_REPO_URL} -b ${PACKIT_REPO_BRANCH} /opt/openwrt_packit"
git clone ${PACKIT_REPO_URL} -b ${PACKIT_REPO_BRANCH} /opt/openwrt_packit

cd /opt/openwrt_packit
if [ -f ${OPENWRT_ARMVIRT} ]; then
    echo "------ 准备rootfs.tar.gz: mv ${OPENWRT_ARMVIRT} ./"
    mv ${OPENWRT_ARMVIRT} ./
else
    echo "------ 准备rootfs.tar.gz: wget -q ${OPENWRT_ARMVIRT}"
    wget -q ${OPENWRT_ARMVIRT}
fi

mkdir kernel && cd kernel
echo "------ 准备kernel: wget -q -O kernel.tar.gz ${KERNEL_REPO_URL}/${KERNEL_VERSION}.tar.gz"
wget -q -O kernel.tar.gz ${KERNEL_REPO_URL}/${KERNEL_VERSION}.tar.gz
tar -zxvf kernel.tar.gz && rm kernel.tar.gz

cd /opt/openwrt_packit
echo "WHOAMI=\"${WHOAMI}\"" >> make.env
echo "KERNEL_VERSION=\"${KERNEL_VERSION_NAME}\"" >> make.env
echo "KERNEL_PKG_HOME=\"/opt/openwrt_packit/kernel\"" >> make.env
echo "OPENWRT_VER=\"${OPENWRT_VER}\"" >> make.env
echo "------ 准备打包环境变量: /opt/openwrt_packit/make.env"
cat /opt/openwrt_packit/make.env

echo "------ 开始打包"
sudo ./${RUN_SH}

echo "------ 打包完成"
cd /opt/openwrt_packit/output
gzip ./*.img && rm ./*.img
mv ../*.tar.gz ./
echo "PACKAGED_OUTPUTDATE=$(date +"%Y.%m.%d.%H%M")" >>$GITHUB_ENV
echo "PACKAGED_OUTPUTPATH=${PWD}" >>$GITHUB_ENV
echo "------ 打包信息: PACKAGED_OUTPUTDATE=$(date +"%Y.%m.%d.%H%M")"
ls -alh
