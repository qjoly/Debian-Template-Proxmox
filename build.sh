#!/bin/bash

# install vm proxmox
export proxmox_url=$(vault kv get -field proxmox_url kv/wysux)
export proxmox_node=$(vault kv get -field proxmox_node kv/wysux)
export proxmox_username=$(vault kv get -field proxmox_user kv/wysux)
export proxmox_password=$(vault kv get -field proxmox_password kv/wysux)
export proxmox_storage="local"
export proxmox_network="vmbr0"

##
#vm caracteristiques
export vm_id=9002
export vm_name="debian-11-tf"
export template_description="VM debian"
export vm_default_user="root"
export vm_cpu=2
export vm_disk="8G"
export vm_memory=1024

# VM root login & deploy user
export prefix_disk="vd"
export ssh_username="root"
export ssh_password="HugePassword"
export userdeploy_password="HugePassword"

export vm_keys=$(echo "$(cat ~/.ssh/id_rsa.pub)")
#export vm_keys=$(echo "$(cat ./KeyDEPLOY.id_rsa.pub)\n$(cat ./KeyINFRA.id_rsa.pub)\n$(cat ~/.ssh/id_rsa.pub)")

# set variables
j2 http/hack.sh.j2 > http/hack.sh
j2 http/preseed.cfg.j2 > http/preseed.cfg

#sshpass -p "${proxmox_password}" ssh "${proxmox_ssh}" "wget ${iso_url} -P /var/lib/vz1/template/iso/"
#PACKER_LOG=1 packer build debian-test.json
packer build debian-11-amd64-proxmox.json

rm -f http/preseed.cfg
rm -f http/hack.sh

