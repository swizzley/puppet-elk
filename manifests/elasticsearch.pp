# type elk::elasticsearch
#
# This provisions an elasticsearch host, both cluster members types and stand-alone
#
define elk::elasticsearch (
  $master,
  $data,
  $parity,
  $cors,
  $unicast,
  $path,
  $cluster_name = $title,
  $role         = 'elastic',
  $org          = 'elk',
  $url_elasticsearch_plugin_hq = 'https://github.com/royrusso/elasticsearch-HQ/archive/v1.0.0.zip') {
  validate_bool($master, $data, $cors)
  validate_integer($parity)
  validate_string($unicast)
  validate_string($org)
  validate_absolute_path($path)

  include elk::java
  require elk::java
  class { '::elasticsearch': 
    manage_repo => true,
    repo_stage => true,
    repo_version => '1.0',
    version => '1.7.1',
  }

  if ($::elk::elk == 'Elastic') {
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
    elasticsearch::instance { "Elasticsearch": }
  }

  elasticsearch::plugin { 'HQ':
    url       => $url_elasticsearch_plugin_hq,
    instances => "Elasticsearch",
  }

}
