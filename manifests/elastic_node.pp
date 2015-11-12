# class elk::elastic_node
class elk::elastic_node ($es_cluster = $::elk::es_cluster, $es_unicast_ip = $::elk::es_unicast_ip, $es_master = $::elk::params::es_master, $c10k = $::elk::params::c10k, $data_dir = $::elk::params::data_dir, $url_elasticsearch_plugin_hq = $::elk::params::url_elasticsearch_plugin_hq) inherits ::elk::params {
  validate_string($es_unicast_ip)
  validate_array($es_cluster)
  validate_absolute_path($data_dir)

  case $::hostname {
    "${master}" : {
      elk::elasticsearch { 'Elasticsearch':
        master  => true,
        data    => true,
        cors    => false,
        parity  => 0,
        unicast => $es_unicast_ip,
        path    => $data_dir,
        url_elasticsearch_plugin_hq => $url_elasticsearch_plugin_hq,
      }
    }
    "${c10k}"   : {
      elk::elasticsearch { 'Elasticsearch':
        master  => false,
        data    => false,
        cors    => true,
        parity  => 0,
        unicast => $es_unicast_ip,
        path    => $data_dir,
        url_elasticsearch_plugin_hq => $url_elasticsearch_plugin_hq,
      }
    }
    default     : {
      elk::elasticsearch { 'Elasticsearch':
        master  => false,
        data    => true,
        cors    => false,
        parity  => 0,
        unicast => $es_unicast_ip,
        path    => $data_dir,
        url_elasticsearch_plugin_hq => $url_elasticsearch_plugin_hq,
      }
    }
  }
}
