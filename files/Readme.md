# Scout-Vagrant

**Table of Contents**

1. [Overview](#overview)
2. [Installation](#installation)
3. [Boxes](#our_boxes)
  * [Public](#public_boxes) 
  * [Private](#private_boxes) 
4. [Vagrantfiles](#vagrantfiles)
5. [Setup](#setup)
6. [Run](#run)

## Overview

Vagrant Files for Developers to use for building local test VMs. These files range in complexity and purpose which why this repo exists. Idealy someone on the team could copy a single file to do anything they would need to do. This is entirely to be used for automating the creation of the developer environment on a local platform in a consistent and simplistic way.  

Currently we're assuming that everyone will use the vagrant provider 'virtualbox' for all vagrant boxes. This is because the licesne for the vagrant vmware fusion plugin is $50 per seat. 

Vagrant is a CLI tool only. Using it will allow you to build, rebuild, and destory entire vms, environments, or stacks with one command, provided there are enough local resources to accomodate the boxes. 

  * [Documentation](https://docs.vagrantup.com/v2/)
  * [Public Box Repo](https://atlas.hashicorp.com/boxes/search)

## Installation

  * Download and install [Vagrant](https://www.vagrantup.com/downloads.html)
  * Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
  
## Our_Boxes

These boxes were built specifically for the Scout team. 

#### Public_Boxes

Create a directory per box, and from within that directory, the vagrant command is always relative to that box. 

  * ```vagrant init swizzley88/centos-6.6-64_puppet-3.8; vagrant up --provider virtualbox```
  
#### Private_Boxes

  * 
  
## Vagrantfiles

  * elk.rb
  
## Setup

1. Fork the repos
2. Create github deploy keys
3. Git clone your vagrant fork
4. Paste keys & ntid into your fork's provision/scout.pp
5. Link a server template in your fork, eg: Scout-Vagrant/Vagrantfile -> Scout-Vagrant/Vagrantfiles/gui.rb
6. ```vagrant up``` or ```vagrant destroy -f && vagrant up``` if you want to start fresh or ```vagrant provision``` if you modified provision/scout.pp or ```vagrant reload``` if you modified Vagrantfile, or changed hardware from VirtualBox gui
7. ```vagrant ssh```
8. ```sudo su -```
9. ```puppet apply -vt --debug site.pp```

  * Fork this repo
  * Create and paste public keys into the deploy keys for your puppet fork and your hiera fork in github
  
  ``` ssh-keygen -f id_rsa.puppet -t rsa -N '' ```
  
  ``` ssh-keygen -f id_rsa.hiera -t rsa -N '' ```
  
  ``` cat ~/.ssh/id_rsa.puppet.pub ```
  
  ``` cat ~/.ssh/id_rsa.hiera.pub ```
  
  
  * Paste the public and private keys into your fork of this repo at the top of provision/scout.pp as variables along with your NTID
  
  ```  # Configure the values for your forks   ```
  
  ```  $deploy_puppet_private = ''  ```
  
  ```  $deploy_puppet_public = ''  ```
  
  ```  $deploy_hiera_private = ''  ```
  
  ```  $deploy_hiera_public = ''  ```
  
  ```  $$deploy_pvtkey_git_ID = ''  ```

  * Clone your fork of this repo onto your local environmet
  * unlink and link the Vagrant file to the file specific to your testing if necessary [default: gui{1cpu, 512mb, NAT}]
 
  ```
  unlink Vagrantfile
  ln -s ./Vagrantfiles/elk.rb Vagrantfile
  ```
 
  * If switching the Vagrantfile after having done a vagrant up, do this after relinking:
 
  ```
  vagrant destroy -f
  vagrant up
  ```
 
  * If changing options to a running Vagrantfile do:
 
  ```
  vagrant reload
  ```
  
## Run

After ```vagrant up```, everything should be good to go, so just login and run puppet. If you want you can create your puppet and hiera forks as git submodules inside your vagrant fork and modify the vagrant files to provision the actual puppet code all at once. =-) That way you just ```vagrant up``` and you're done, but because those submodules are specific to individual forks, there's no reasonable way to make that part of this upstream repo.

  ```
  vagrant up
  ```
