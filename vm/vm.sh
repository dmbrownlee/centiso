#!/bin/bash

# Without arguments, this script quickly allocates the VMs we need to test the
# project without the need for Vagrant, packer, and vagrant baseboxes.
# Alternatively, you can use it to create additional VMs by passing arguments.
# At a minimum, you need to specify a hostname.  The format is:
#
# ./vm.sh [hostname] [RAM MB] [DISK MB] [int|ext|both] [/path/to/iso] [MAC]

function new-vm {
  HOST="$1"
  OS="${2:-RedHat_64}"
  RAM=${3:-2048}
  DISKMB=${4:-102400}
  NIC=${5:-int}
  ISO=${6:-emptydrive}
  MAC=${7}

  if [[ -n $MAC ]]; then
    MAC="--macaddress1 ${MAC}"
  fi

  # We only care about MAC on internal interfaces
  NICINT1='--nic1 intnet --intnet1 internal --nicpromisc1 allow-vms --cableconnected1 on --nictype1=82540EM'
  NICINT1="$NICINT1 $MAC"
  NICEXT1='--nic1 nat --nicpromisc1 allow-vms --cableconnected1 on --nictype1=82540EM'
  NICEXT2='--nic2 nat --nicpromisc2 allow-vms --cableconnected2 on --nictype2=82540EM'

  echo "=== $OS ==="
  vboxmanage createvm --name "$HOST" --ostype "$OS" --register
  vboxmanage storagectl "$HOST" --name "IDE" --add ide --controller "PIIX4" --portcount "2" --bootable "on"
  vboxmanage storagectl "$HOST" --name "SATA" --add sata --controller "IntelAhci" --portcount "30" --bootable "on"
  vboxmanage modifyvm "$HOST" --memory $RAM
  vboxmanage modifyvm "$HOST" --vram 16
  vboxmanage modifyvm "$HOST" --boot1 "dvd"
  vboxmanage modifyvm "$HOST" --boot2 "disk"
  vboxmanage modifyvm "$HOST" --boot3 "none"
  vboxmanage modifyvm "$HOST" --boot4 "none"
  vboxmanage modifyvm "$HOST" --rtcuseutc "on"
  vboxmanage createhd --filename "$HOME/VirtualBox VMs/$HOST/$HOST-disk001.vmdk" --size $DISKMB --format "VMDK"
  vboxmanage storageattach "$HOST" --storagectl "IDE" --port 0 --device 0 --type "dvddrive" --medium "$ISO"
  vboxmanage storageattach "$HOST" --storagectl "SATA" --port 0 --device 0 --type "hdd" --medium "$HOME/VirtualBox VMs/$HOST/$HOST-disk001.vmdk"
  case $NIC in
    "int")
      vboxmanage modifyvm "$HOST" $NICINT1
      ;;
    "ext")
      vboxmanage modifyvm "$HOST" $NICEXT1
      ;;
    "both")
      # When you have both interfaces, the first is internal
      vboxmanage modifyvm "$HOST" $NICINT1
      vboxmanage modifyvm "$HOST" $NICEXT2
      ;;
  esac
}

if [[ -z "$1" ]]; then
  new-vm buildbox RedHat_64 2048 102400 ext "$HOME/Downloads/CentOS-7-x86_64-NetInstall-1611.iso"
  new-vm router RedHat_64 2048 102400 both emptydrive
  new-vm chefserver RedHat_64 2048 102400 int emptydrive 0800276F9FE1
  new-vm workstation RedHat_64 2048 102400 int emptydrive
  new-vm mdtserver Windows2012_64 2048 102400 int emptydrive
else
  new-vm $@
fi
