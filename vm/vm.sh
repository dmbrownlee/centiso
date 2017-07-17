#!/bin/bash

# This script quickly spins up the bare bones VMs we need to test the project
# without the need for Vagrant, packer, and vagrant baseboxes.

function new-vm {
  HOST="$1"
  RAM=${2:-2048}
  DISKMB=${3:-102400}
  NIC=${4:-int}
  ISO=${5:-emptydrive}

  vboxmanage createvm --name "$HOST" --ostype "RedHat_64" --register
  vboxmanage storagectl "$HOST" --name "IDE" --add ide --controller "PIIX4" --portcount "2" --bootable "on"
  vboxmanage storagectl "$HOST" --name "SATA" --add sata --controller "IntelAhci" --portcount "30" --bootable "on"
  vboxmanage modifyvm "$HOST" --memory $RAM
  vboxmanage modifyvm "$HOST" --vram 16
  vboxmanage modifyvm "$HOST" --boot1 "dvd"
  vboxmanage modifyvm "$HOST" --boot2 "disk"
  vboxmanage modifyvm "$HOST" --boot3 "none"
  vboxmanage modifyvm "$HOST" --boot4 "none"
  vboxmanage modifyvm "$HOST" --rtcuseutc "on"
  vboxmanage createmedium disk --filename "$HOME/VirtualBox VMs/$HOST/$HOST-disk001.vmdk" --size $DISKMB --format "VMDK"
  vboxmanage storageattach "$HOST" --storagectl "IDE" --port 0 --device 0 --type "dvddrive" --medium "$ISO"
  vboxmanage storageattach "$HOST" --storagectl "SATA" --port 0 --device 0 --type "hdd" --medium "$HOME/VirtualBox VMs/$HOST/$HOST-disk001.vmdk"
  case $NIC in
    "int")
      vboxmanage modifyvm "$HOST" --nic1 "intnet" --intnet1 "internal" --nicpromisc1 "allow-vms" --cableconnected1 "on"
      ;;
    "ext")
      vboxmanage modifyvm "$HOST" --nic1 "nat" --nicpromisc1 "allow-vms" --cableconnected1 "on"
      ;;
    "both")
      # When you have both interfaces, the first is internal
      vboxmanage modifyvm "$HOST" --nic1 "intnet" --intnet1 "internal" --nicpromisc1 "allow-all" --cableconnected1 "on"
      vboxmanage modifyvm "$HOST" --nic2 "nat" --nicpromisc2 "allow-vms" --cableconnected2 "on"
      ;;
  esac
}

if [[ -z "$1" ]]; then
  new-vm buildbox 2048 102400 ext "$HOME/Downloads/CentOS-7-x86_64-NetInstall-1611.iso"
  new-vm router 2048 102400 both emptydrive
  new-vm chef 2048 102400 int emptydrive
else
  new-vm $@
fi
