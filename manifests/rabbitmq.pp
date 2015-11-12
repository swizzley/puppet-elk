# class elk::rabbitmq
#
# This rabbitMQ instance is to act as a buffer for logstash input
# It will help ensure no messages are lost, and act as a single point
# Of Collection for all lumberjack nodes
#
class elk::rabbitmq (
  $kib_cluster = $::elk::params::kib_cluster,
  $es          = $::elk::params::es_front,
  $logstash_mq = $::elk::params::logstash_mq,
  $rmq_user    = $::elk::params::rmq_user,
  $rmq_pass    = $::elk::params::rmq_pass,
  $rmq_admin   = $::elk::params::rmq_admin,
  $rmq_key     = $::elk::params::rmq_key,) inherits ::elk::params {
  # Prerequisites
  include ::rabbitmq

  rabbitmq_vhost { 'logstash': ensure => present, }

  rabbitmq_user { $rmq_user:
    admin    => true,
    password => $rmq_pass,
  } ->
  rabbitmq_user_permissions { "${rmq_user}@logstash":
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  rabbitmq_queue { 'logstash@logstash':
    user        => $rmq_user,
    password    => $rmq_pass,
    durable     => true,
    auto_delete => false,
    ensure      => present,
  }

  rabbitmq_exchange { 'logstash-rabbitmq@logstash':
    user        => $rmq_user,
    password    => $rmq_pass,
    type        => 'direct',
    ensure      => present,
    internal    => false,
    auto_delete => false,
    durable     => true,
    arguments   => {
      hash-header => 'message-distribution-hash'
    }
  }

  rabbitmq_binding { 'logstash-rabbitmq@logstash@logstash':
    user             => $rmq_user,
    password         => $rmq_pass,
    destination_type => 'queue',
    routing_key      => 'logstash',
    ensure           => present,
  }
  
  file_line { 'sudo_sudoers.d':
    ensure   => present,
    path     => '/etc/sudoers',
    line     => '#includedir /etc/sudoers.d',
    match    => '^#includedir.*',
    multiple => false,
    replace  => false,
  }
  
  file { '/etc/sudoers.d/rmq_root_no_tty':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    content => "Defaults:root !requiretty \n",
    require => File_line['sudo_sudoers.d'],
  }
  
  exec { 'ha_queues':
    path    => '/bin:/usr/bin:/usr/sbin',
    command => 'sudo -u root /usr/sbin/rabbitmqctl set_policy -p logstash ha-all "^.*" \'{"ha-mode":"all", "ha-sync-mode":"automatic", "ha-promote-on-shutdown":"always"}\'',
    unless  => 'sudo -u root /usr/sbin/rabbitmqctl list_policies -p logstash|grep ha|grep sync|grep auto|grep promote|grep always|grep -q all',
    user    => 'root',
    require => [Service['rabbitmq-server'], File['/etc/sudoers.d/rmq_root_no_tty']]
  }
}
