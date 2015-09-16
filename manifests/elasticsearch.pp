# type elk::elasticsearch
#
# This provisions an elasticsearch host, both cluster members types and stand-alone
#
define elk::elasticsearch ($master, $data, $parity, $cors, $unicast, $path, $cluster_name = $title, $role = 'elastic') {
  validate_bool($master, $data, $cors)
  validate_integer($parity)
  validate_string($unicast)
  validate_absolute_path($path)

  include scout::elk::java
  require scout::elk::java
  include ::elasticsearch

  if ($role == 'elastic') {
    elasticsearch::instance { $name:
      config => {
        'cluster.name'             => $name,
        'node.name'                => $::hostname,
        'node.master'              => $master,
        'node.data'                => $data,
        'node.parity'              => $parity,
        'http.cors.enabled'        => $cors,
        'path.data'                => $path,
        'discovery.zen.ping.unicast.hosts'     => "[${unicast}]",
        'discovery.zen.minimum_master_nodes'   => 1,
        'discovery.zen.ping.multicast.enabled' => false,
        'discovery.zen.fd.ping_interval'       => '1s',
        'discovery.zen.fd.ping_timeout'        => '60s',
        'discovery.zen.fd.ping_retries'        => 6,
        'bootstrap.mlockal'        => true,
        'cluster.routing.allocation.node_concurrent_recoveries' => 4,
        'indices.recovery.max_bytes_per_sec'   => '100mb',
        'indices.recovery.concurrent_streams'  => 10,
        'index.search.slowlog.threshold.query.warn'             => '10s',
        'index.search.slowlog.threshold.fetch.warn'             => '1s',
        'index.indexing.slowlog.threshold.index.warn'           => '10s',
        'network.tcp.keep_alive'   => true,
        'swift.repository.enabled' => true,
      }
    }
  } else {
    elasticsearch::instance { "ELK": }
  }

  file { '/app/platform/elasticsearch/bin/plugin':
    ensure => link,
    target => '/usr/share/elasticsearch/bin/plugin',
  }

  file { '/app/platform/elasticsearch/bin/elasticsearch':
    ensure => link,
    target => '/usr/share/elasticsearch/bin/elasticsearch',
  }

  file { '/app/platform/elasticsearch/plugins/HQ':
    ensure => link,
    target => '/usr/share/elasticsearch/plugins/HQ',
  }

  elasticsearch::plugin { 'HQ':
    url       => 'http://yumrepo.sys.comcast.net/se_networkscout/noarch/noarch/ELK/royrusso-elasticsearch-HQ-603ae9e.zip',
    instances => "${::org}",
    require   => [File['/app/platform/elasticsearch/bin/plugin'], File['/app/platform/elasticsearch/plugins/HQ'],]
  }

}