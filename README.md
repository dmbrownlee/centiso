# centiso
Automate creating custom CentOS ISO images

This is an ansible playbook to automate building a custom ISO images for CentOS 7.  The playbook includes a kickstart file that can be used for an unattended install of a base machine.

## Requirements
The commands in the playbook assume you are running the commands on an existing CentOS machine with ansbile (2.3.1 was current when this was written).  Furthermore, the playbook requires you to have the genisoimage and createrepo packages installed.

## Downloading
Run the following in your home directory to clone this project:

    git clone https://github.com/dmbrownlee/centiso.git

This will create ~/centiso as a git working directory.

## Building a custom CentOS 7 ISO
On CentOS 7, follow these steps:

    cd ~/centiso/ansible
    ansible-playbook -i inventory playbook.yml

This will create the working directories, download CentOS-7-x86_64-Everything-1611.iso to /var/centiso/ (the most time consuming part unless it is already there), and then create /var/centiso/CentOS-7-x86_64-Custom.iso which includes a kickstart file that will do an unattended install of a base CentOS 7 system. 

## Details of the base machine installed by the created ISO
The ISO this playbook creates includes a kickstart file that defaults to installing a base CentOS 7 machine.  The disk is encrypted with "root" as the default password to unlock encryption.  At the console login, you can use "root" as the username and password to log into the root account.  The kickstart post script expires the root user's password so you will be forced to reset the root password on the first login.  This does not change the disk encryption password which will remain "root" untill you change it by hand.

## VirtualBox VM
If you don't have a CentOS 7 workstation but do have a system with Vagrant and VirtualBox installed, you can try spinning up a VM using the Vagrantfile in the vm directory with:

    cd ~/centiso/vm
    vagrant up

This will use the centos/7 vagrant base box image in the atlus repo to spin up a CentOS 7 VM, install the required packages, install the latest version of ansible, and clone this repo under /root so you can try it out.  I recommend you try using packer to build your own base box image with support for VirtualBox shared folders and make /var/centiso a shared folder so you can setup and tear down the VM at will while keeping your ISO images in the host machine's filesystem.
