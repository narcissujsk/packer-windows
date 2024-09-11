#!/usr/bin/env bash
set -x
set -e

lsmod
#modprobe kvm
#modprobe kvm_intel


#ISO_URL=http://10.221.128.158:90/isos/win/cn_windows_server_2019_x64_dvd_4de40f33.iso
ISO_URL=http://vm-image.oss.jinan-lab.inspurcloudoss.com/iso/windows/windows%20server%202019/cn_windows_server_2019_updated_jan_2020_x64_dvd_4bbe2c37.iso

VM_NAME="out-image"
DIR_NAME="./out"
IMAGE_NAME="${VM_NAME}.qcow2"
#VM_PASSWORD=Lc13yfwpW
VM_PASSWORD=KSNsMdY?jeGt@fA
VM_PORT1=33894
VM_PORT2=59854
GITLAB_TOKEN=xwq9rYkSwxDig-e4GdU3


echo ======================================           build image          ==============================================
#构建镜像
mkdir -p /var/lib/libvirt/qemu/channel/target/vm/
export PACKER_LOG=1
export PACKER_LOG_PATH="./packer.log"
/opt/packer build -var "outdir=${DIR_NAME}" -var "vmname=${IMAGE_NAME}" -var "isourl=${ISO_URL}" WIN2019DCx86_64.json

echo ======================================      get image md5     =================================================
md5=`md5sum ${DIR_NAME}/${IMAGE_NAME} | cut -d " " -f 1`
echo ${md5}


echo ================================================== done ======================================================
