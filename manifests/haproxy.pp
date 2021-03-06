# class elk::haproxy
#
# This is a HA proxy for the frontend user interface Kibana
#
class elk::haproxy (
  $kib_cluster     = $::elk::params::kib_cluster,
  $kib_cluster_ips = $::elk::params::kib_cluster_ips,
  $logstash_mq     = $::elk::params::logstash_mq,
  $logstash_mq_ips = $::elk::lparams::ogstash_mq_ips,
  $es_cluster      = $::elk::params::es_cluster,
  $es_cluster_ips  = $::elk::params::es_cluster_ips,
  $log_cluster     = $::elk::params::log_cluster,
  $log_cluster_ips = $::elk::params::log_cluster_ips,) inherits ::elk::params {
  # Prerequisites
  include ::haproxy
  $elastic_cluster = suffix($es_cluster, ".${::domain}")

  # LB Kibana
  if ($::elk::elk != 'ELK') {
    haproxy::listen { 'kibana':
      mode      => 'tcp',
      ipaddress => $::ipaddress_eth1,
      #[TODO]ipaddress => $::ipaddress,
      ports     => '80',
      options   => {
        'option'  => ['tcplog'],
        'balance' => 'roundrobin',
        'log'     => 'global',
      }
      ,
    } ->
    haproxy::balancermember { 'kibana':
      listening_service => 'kibana',
      server_names      => $kib_cluster,
      ipaddresses       => $kib_cluster_ips,
      ports             => '5601',
      options           => 'check',
    }

    haproxy::listen { 'rabbitmq-server':
      mode      => 'tcp',
      ipaddress => $::ipaddress_eth1,
      #[TODO]ipaddress => $::ipaddress,
      ports     => '5672',
      options   => {
        'option'  => ['tcplog'],
        'balance' => 'roundrobin',
        'log'     => 'global',
      }
      ,
    } ->
    haproxy::balancermember { 'rabbitmq-server':
      listening_service => 'rabbitmq-server',
      server_names      => $logstash_mq,
      ipaddresses       => $logstash_mq_ips,
      ports             => '5672',
      options           => 'check',
    }

    haproxy::listen { 'rabbitmq-gui':
      mode      => 'tcp',
      ipaddress => $::ipaddress_eth1,
      #[TODO]ipaddress => $::ipaddress,
      ports     => '15672',
      options   => {
        'option'  => ['tcplog'],
        'balance' => 'roundrobin',
        'log'     => 'global',
      }
      ,
    } ->
    haproxy::balancermember { 'rabbitmq-gui':
      listening_service => 'rabbitmq-gui',
      server_names      => $logstash_mq,
      ipaddresses       => $logstash_mq_ips,
      ports             => '15672',
      options           => 'check',
    }

    haproxy::listen { 'elasticsearch-out':
      mode      => 'tcp',
      ipaddress => $::ipaddress_eth1,
      #[TODO]ipaddress => $::ipaddress,
      ports     => '9200',
      options   => {
        'option'  => ['tcplog'],
        'balance' => 'roundrobin',
        'log'     => 'global',
      }
      ,
    } ->
    haproxy::balancermember { 'elasticsearch-out':
      listening_service => 'elasticsearch-out',
      server_names      => $elastic_cluster,
      ipaddresses       => $es_cluster_ips,
      ports             => '9200',
      options           => 'check',
    }
    
    haproxy::listen { 'elasticsearch-in':
      mode      => 'tcp',
      ipaddress => $::ipaddress_eth1,
      #[TODO]ipaddress => $::ipaddress,
      ports     => '9300',
      options   => {
        'option'  => ['tcplog'],
        'balance' => 'roundrobin',
        'log'     => 'global',
      }
      ,
    } ->
    haproxy::balancermember { 'elasticsearch-in':
      listening_service => 'elasticsearch-in',
      server_names      => $elastic_cluster,
      ipaddresses       => $es_cluster_ips,
      ports             => '9300',
      options           => 'check',
    }

    haproxy::listen { 'lumberjack':
      mode      => 'tcp',
      ipaddress => $::ipaddress_eth1,
      #[TODO]ipaddress => $::ipaddress,
      ports     => '5000',
      options   => {
        'option'  => ['tcplog'],
        'balance' => 'roundrobin',
        'log'     => 'global',
      }
      ,
    } ->
    haproxy::balancermember { 'lumberjack':
      listening_service => 'lumberjack',
      server_names      => $log_cluster,
      ipaddresses       => $log_cluster_ips,
      ports             => '5000',
      options           => 'check',
    }

  } else {
    haproxy::balancermember { 'kibana':
      listening_service => 'kibana',
      server_names      => $kib_cluster,
      ipaddresses       => $kib_cluster_ips,
      ports             => '5601',
      options           => 'check',
    } ->
    haproxy::listen { 'kibana':
      mode      => 'tcp',
      ipaddress => $::ipaddress_eth1,
      #[TODO]ipaddress => $::ipaddress,
      ports     => '80',
      options   => {
        'option'  => ['tcplog'],
        'balance' => 'roundrobin',
        'log'     => 'global',
      }
      ,
    }
  }
}
