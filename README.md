# packer-ubuntu-20.04

## About
A Packer template to create Ubuntu 20.04 "Focal Fossa" Server boxes for Vagrant.

## Usage
To create VirtualBox virtual machine.
```bash
packer build ubuntu.json
```
To create Hyper-V virtual machine.
```sh
packer build ubuntu-hyperv.json
```

### Ubuntu Server 20.04.1
Tested with [Packer][] 1.6.0, [Vagrant][] 2.2.9, [VirtualBox][] 6.1.12

[Packer]: https://packer.io/
[Vagrant]: https://www.vagrantup.com/
[VirtualBox]: https://www.virtualbox.org/
