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
  $rmq_user    = $::elk::params::elk_rmq_user,
  $rmq_pass    = $::elk::params::elk_rmq_pass,
  $rmq_admin   = $::elk::params::elk_rmq_admin,
  $rmq_key     = $::elk::params::elk_rmq_key,) inherits ::elk::params {
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

  # exec { 'set_password': command => "/usr/sbin/rabbitmqctl change_password ${rmq_admin} ${rmq_pass}" }

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
}