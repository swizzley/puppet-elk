#class elk::vagrant_provisioning
class elk::vagrant_provisioning($secure_install = $::elk::params::secure_install)inherits elk::params {

# Configure the values for your forks
$pvtkey_puppet = ''
$pvbkey_puppet = ''
$pvtkey_hiera = ''
$pubkey_hiera = ''

# Git Deploy Key
$git_host = ''
$git_username = ''
$vagrant_start = 'exec{\'initial puppet run\': command => \'/usr/bin/puppet apply -t /etc/puppet/manifests/site.pp\'}'

# Configure Vagrant
$vagrant_home = '/root'

  file{"${vagrant_home}": 
    ensure => directory, 
  }->
  file{"${vagrant_home}/provision": 
    ensure => directory, 
    mode => '0644', 
    content => template(elk/swizzley88-elk.pp.erb),
  }->
  file{"${vagrant_home}/provision/swizzley88-elk.pp": 
    ensure => present, 
    mode => '0644', 
    content => template(elk/swizzley88-elk.pp.erb),
  }->
  file{"${vagrant_home}/Vagrantfile": 
    ensure => present, 
    mode => '0644', 
    source => 'puppet:///modules/elk/elk.rb',
  }

}
