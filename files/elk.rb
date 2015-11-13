#***
#*
#* ELK Vagrant stack using swizzley88-elk puppet module
#*              11.01.15
#*              Memory: 10 nodes x 1024mb NAT: 10x
#* Puppet Module: 'https://github.com/swizzley/puppet-elk/blob/master/modules/manifests/init.pp'
#*
#***
Vagrant.configure("2") do |config|
    config.vm.box = "swizzley88/centos-6.6-64_puppet-3.8"

    ls_port = { 'elk-vg-v1d' => 5000, 'log-vg-v1d' => 6000, 'log-vg-v2d' => 7000 }
    mq_port = { 'elk-vg-v1d' => 5672, 'elkq-vg-v1d' => 5772, 'elkq-vg-v2d' => 5872 }
    mu_port = { 'elk-vg-v1d' => 15672, 'elkq-vg-v1d' => 25672, 'elkq-vg-v2d' => 35672 }
    ei_port = { 'elk-vg-v1d' => 9200, 'es-vg-v1d' => 9400, 'es-vg-v2d' => 9600, 'es-vg-v3d' => 9800 }
    eo_port = { 'elk-vg-v1d' => 9300, 'es-vg-v1d' => 9500, 'es-vg-v2d' => 9700, 'es-vg-v3d' => 9900 }
    kb_port = { 'kib-vg-v1d' => 5601, 'kib-vg-v2d' => 6601 }
    hp_port = { 'elk-vg-v1d' => 80 }
    ssh_port = { 'log-vg-v1d' => 2085, 'log-vg-v2d' => 2086, 'kib-vg-v1d' => 2087, 'kib-vg-v2d' => 2089, 'elkq-vg-v1d' => 2090, 'elkq-vg-v2d' => 2091, 
      'es-vg-v1d' => 2092, 'es-vg-v2d' => 2093, 'es-vg-v3d' => 2094, 'elk-vg-v1d' => 2095
        }
        elk_servers  = { 
        'elk-vg-v1d' => '10.0.2.24',
        }
        log_servers  = { 'log-vg-v1d' => '10.0.2.15', 'log-vg-v2d' => '10.0.2.16',
        }
        mq_servers  = { 'elkq-vg-v1d' => '10.0.2.17', 'elkq-vg-v2d' => '10.0.2.18',
        }
        es_servers  = { 'es-vg-v1d' => '10.0.2.19', 'es-vg-v2d' => '10.0.2.20', 'es-vg-v3d' => '10.0.2.21', 
        }
        kib_servers  = {'kib-vg-v1d' => '10.0.2.22', 'kib-vg-v2d' => '10.0.2.23',
        }
    elk_servers.each do |svr_name, svr_ip|
        config.vm.define svr_name do |elk|
            elk.vm.host_name = "#{svr_name.to_s}"  
            elk.vm.network :forwarded_port, guest: 22, host: ssh_port[svr_name], auto_correct: true  
            elk.vm.network :forwarded_port, guest: 5000, host: ls_port[svr_name], auto_correct: true
            elk.vm.network :forwarded_port, guest: 5672, host: mq_port[svr_name], auto_correct: true
            elk.vm.network :forwarded_port, guest: 15672, host: mu_port[svr_name], auto_correct: true
            elk.vm.network :forwarded_port, guest: 9200, host: ei_port[svr_name], auto_correct: true
            elk.vm.network :forwarded_port, guest: 9300, host: eo_port[svr_name], auto_correct: true
            elk.vm.network :forwarded_port, guest: 80, host: hp_port[svr_name], auto_correct: true
            elk.vm.network :private_network, type: "dhcp"  

        # virtualbox
        config.vm.provider "virtualbox" do |v|
            v.customize ["modifyvm", :id, "--memory", 1024]
        end
        # provisioner
        config.vm.provision "puppet" do |puppet|
            puppet.manifests_path = "provision"
            puppet.manifest_file = "swizzley88-elk.pp"
        end
      end
    end
    log_servers.each do |svr_name, svr_ip|
        config.vm.define svr_name do |log|
            log.vm.host_name = "#{svr_name.to_s}"  
            log.vm.network :forwarded_port, guest: 22, host: ssh_port[svr_name], auto_correct: true  
            log.vm.network :forwarded_port, guest: 5000, host: ls_port[svr_name], auto_correct: true
            log.vm.network :private_network, type: "dhcp"  

        # virtualbox
        config.vm.provider "virtualbox" do |v|
            v.customize ["modifyvm", :id, "--memory", 1024]
        end
        # provisioner
        config.vm.provision "puppet" do |puppet|
            puppet.manifests_path = "provision"
            puppet.manifest_file = "swizzley88-elk.pp"
        end
      end
    end    
    mq_servers.each do |svr_name, svr_ip|
        config.vm.define svr_name do |mq|
            mq.vm.host_name = "#{svr_name.to_s}"  
            mq.vm.network :forwarded_port, guest: 22, host: ssh_port[svr_name], auto_correct: true  
            mq.vm.network :forwarded_port, guest: 5672, host: mq_port[svr_name], auto_correct: true
            mq.vm.network :forwarded_port, guest: 15672, host: mu_port[svr_name], auto_correct: true
            mq.vm.network :private_network, type: "dhcp"  

        # virtualbox
        config.vm.provider "virtualbox" do |v|
            v.customize ["modifyvm", :id, "--memory", 1024]
        end
        # provisioner
        config.vm.provision "puppet" do |puppet|
            puppet.manifests_path = "provision"
            puppet.manifest_file = "swizzley88-elk.pp"
        end
      end
    end
    es_servers.each do |svr_name, svr_ip|
        config.vm.define svr_name do |es|
            es.vm.host_name = "#{svr_name.to_s}"  
            es.vm.network :forwarded_port, guest: 22, host: ssh_port[svr_name], auto_correct: true  
            es.vm.network :forwarded_port, guest: 9200, host: ei_port[svr_name], auto_correct: true
            es.vm.network :forwarded_port, guest: 9300, host: eo_port[svr_name], auto_correct: true
            es.vm.network :private_network, type: "dhcp" 

        # virtualbox
        config.vm.provider "virtualbox" do |v|
            v.customize ["modifyvm", :id, "--memory", 1024]
        end
        # provisioner
        config.vm.provision "puppet" do |puppet|
            puppet.manifests_path = "provision"
            puppet.manifest_file = "swizzley88-elk.pp"
        end
      end
    end
    kib_servers.each do |svr_name, svr_ip|
        config.vm.define svr_name do |kib|
            kib.vm.host_name = "#{svr_name.to_s}"  
            kib.vm.network :forwarded_port, guest: 22, host: ssh_port[svr_name], auto_correct: true  
            kib.vm.network :forwarded_port, guest: 5601, host: kb_port[svr_name], auto_correct: true
            kib.vm.network :private_network, type: "dhcp"  

        # virtualbox
        config.vm.provider "virtualbox" do |v|
            v.customize ["modifyvm", :id, "--memory", 1024]
        end
        # provisioner
        config.vm.provision "puppet" do |puppet|
            puppet.manifests_path = "provision"
            puppet.manifest_file = "swizzley88-elk.pp"
        end
      end
    end
end
