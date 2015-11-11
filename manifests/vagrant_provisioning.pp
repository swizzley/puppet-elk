#class elk::vagrant_provisioning
class elk::vagrant_provisioning($secure_install = $::elk::params::secure_install)inherits elk::params {

# Configure the values for your forks
$pvtkey_puppet = ''
$pvbkey_puppet = ''
$pvtkey_hiera = ''
$pubkey_hiera = ''

#Git Deploy Key
$git_host = ''
$git_username = ''
$vagrant_start = 'exec{'initial puppet run': command => '/usr/bin/puppet apply -t /etc/puppet/manifests/site.pp'}'

  file{'/etc/puppet/manifests/site.pp': 
    ensure => present, 
    mode => '0644', 
    content => template(elk/swizzley88-elk.pp.erb),
  }

}
