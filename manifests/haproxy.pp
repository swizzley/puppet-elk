# class elk::haproxy
#
# This is a HA proxy for the frontend user interface Kibana
#
class elk::haproxy (
  $kib_cluster     = $::scout::params::kib_cluster,
  $es              = $::scout::params::es_front,
  $kib_cluster_ips = $::scout::params::kib_cluster_ips) inherits ::scout::params {
  # Prerequisites
  include ::haproxy

  # LB Kibana
  haproxy::balancermember { 'kibana':
    listening_service => 'kibana',
    server_names      => $kib_cluster,
    ipaddresses       => [$kib_cluster_ips],
    ports             => '5601',
    options           => 'check',
  } ->
  haproxy::listen { 'kibana':
    mode      => 'tcp',
    ipaddress => $::ipaddress,
    ports     => '80',
    options   => {
      'option'  => ['tcplog'],
      'balance' => 'roundrobin',
      'log'     => 'global',
    }
    ,
  }
}