# class elk::rabbitmq
#
# This rabbitMQ instance is to act as a buffer for logstash input
# It will help ensure no messages are lost, and act as a single point
# Of Collection for all lumberjack nodes
#
class elk::rabbitmq (
  $rmq_user       = $::elk::params::rmq_user,
  $rmq_pass       = $::elk::params::rmq_pass,
  $rmq_admin      = $::elk::params::rmq_admin,
  $rmq_key        = $::elk::params::rmq_key,
  $cluster        = $::elk::params::logstash_mq,
  $erlang_cookie  = $::elk::params::erlang_cookie,) inherits ::elk::params {
  # Prerequisites
  class { '::rabbitmq': 
    package_provider         => 'yum',
    cluster_nodes            => $cluster,
    erlang_cookie            => $erlang_cookie,
    config_cluster           => true,
    wipe_db_on_cookie_change => true,
  }

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
  
}
