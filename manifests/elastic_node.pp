# class elk::elastic_node
class elk::elastic ($es_cluster = $::scout::elk::es_cluster, $es_unicast_ip = $::scout::elk::es_unicast_ip, $es_master = $::elk::params::es_master, $c10k = $::elk::params::c10k, $datadir = $::elk::params::datadir, $es_unicast_ip = $::elk::params::es_unicast_ip) inherits ::elk::params {
  validate_string($es_unicast_ip)
  # Variables
  $master = values_at($es_cluster, 0)
  $c10k = values_at(reverse($es_cluster), 0)
  $data_dir = '/app/platform/elasticsearch/data'

  case $::hostname {
    "${master}" : {
      elk::elasticsearch { 'Elasticsearch':
        master  => true,
        data    => true,
        cors    => false,
        parity  => 0,
        unicast => $es_unicast_ip,
        path    => $data_dir,
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
      }
    }
  }
}
