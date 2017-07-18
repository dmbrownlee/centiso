# centiso
Originally a project to create an Ansible playbook to automate creating custom CentOS 7 ISO images, this project as since grown into project to demonstrate growing an IT infrastructure from scratch.

This is an ansible playbook to automate building a custom ISO images for CentOS 7.  The playbook includes a kickstart file that can be used for an unattended install of a base machine.

## End Goal
The current end goal is to have an infrastructure that supports unattended installs of workstations and servers via PXE booting and kickstart files.

The next milestone is getting chef development environment deployed.

## Prerequisites
I'm doing development using VirtualBox VMs on Mac. I expect it to work in VirtualBox VMs on Linux but I'm not testing that.

Steps to setup a similar environment:
- Install VirtualBox
- Install the VirtualBox extension pack (needed for PXE booting VMs)
- Install XCode (provides host OS with git)

## Getting started
Run the following in your home directory to clone this project:

    `$ **git clone https://github.com/dmbrownlee/centiso.git**`

This will create `~/centiso` as a git working directory.  Next, run:

    `cd ~/centiso/vm && ./vm.sh`

This creates the initial VMs for the project.

Finally, download the latest NetInstall ISO image for CentOS 7 from the `centos/7/isos/x86_64/` directory of a mirror close to you (see [link](https://www.centos.org/download/mirrors/)).

### buildbox
We start as if you had no infrastructure at all beyond internet access, for example, through a consumer router.  The buildbox has nothing on it.  In a real scenario you might use another computer to download CentOS 7 install media, burn it to a DVD drive, and manually install the workstation.  Then you could take the generated anaconda-ks.cfg file an tweak it to install just what you need. Of course you would want to keep this config checked into source control such as a repo on GitHub (I saved mine as bootstrap-ks.cfg since it builds the first machine on our network). Once on GitHub, you can now recreate your buildbox, mostly unattended, with just the small NetInstall ISO image.

Let's do that now:
1. The NetInstall ISO image should already be attached to the buildbox optical drive.  Boot the VM.
2. At the installation menu, highlight "`Install CentOS Linux 7`" and press the `tab` key to edit the boot command
3. Append the following to the boot command and press `enter`:
    `inst.ks=https://raw.githubusercontent.com/dmbrownlee/centiso/master/files/bootstrap-ks.cfg`

NOTE: The disk encryption password is "root" and you should probably change that.

Then you could install Ansible and start writing a playbook to create your own custom ISO image with just the packages you need and tweek the install menu to offer generic configurations for workstations and servers.  This will give you an emergency ISO with which you can spin up your environment but it would be better if you could PXE install the machines in your environment rather than install each one with media. To that end, you develop another additional ansible playbooks to configure all the infrastuctuer services you will need to PXE in your environment. Since it would be nice to deploy this when you don't have a network, you create a kickstart file to build this infrastructure server and include it on your custom ISO image.

Let's create our custom ISO image now:
1. Login to the buildbox as root
2. `$ **cd ~/centiso/ansible && ansible-playbook tasks/bootstrap-build-iso.yml**`

This will create a custom ISO image you can use to install the router VM.  You will want to scp the custom ISO image to the host OS (enable remote login if you haven't already).

### router
Router is the first machine that will be part of our infrastructure.  As it is an all-in-one infrastructure server, it has two network interfaces to provide NAT routing to the Internet from our internal network.

Let's install router using the custom ISO image we created

1. "Insert" the ISO file in the router VM and boot it
2. Choose "Gateway" from the install menu

NOTE: The following should be built into the install but currently is not

3. Login to router as root
4. `$ **cd ~/centiso/ansible && ansible-playbook -i inventory --limit router playbook.yml**`

NOTE: The last step will take a while as it creates a local CentOS mirror on router.

Router should now be providing everything you need to PXE boot install other VMs on the internal network.

### chefserver
Let's test PXE installs on chefserver

1. Boot chefserver and immediatly press `fn-F12` and boot from the LAN with '`l`'
2. Choose to install the Generic Server

### more to follow...
