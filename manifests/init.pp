# Class: elk
#
# This module deploys the ELK stack in the best way
#
class elk ($elk = $::elk::params::elk, $cluster_name = $::elk::params::cluster_name, $es_master = $::elk::params::es_master, $c10k = $::elk::params::c10k, $datadir = $::elk::params::datadir, $es_unicast_ip = $::elk::params::es_unicast_ip) inherits ::elk::params {
  validate_string($es_unicast_ip)
  case $elk {
    'Elastic'  : {
      case $::hostname {
        "${es_master}" : {
          elk::elasticsearch { $cluster_name:
            master  => true,
            data    => true,
            cors    => false,
            parity  => 0,
            unicast => $es_unicast_ip,
            path    => $data_dir,
          }
        }
        "${c10k}"      : {
          elk::elasticsearch { $cluster_name:
            master  => false,
            data    => false,
            cors    => true,
            parity  => 0,
            unicast => $es_unicast_ip,
            path    => $data_dir,
          }
        }
        default        : {
          elk::elasticsearch { $cluster_name:
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
    'Logstash' : {
      include elk::logstash
    }
    'Kibana'   : {
      include elk::kibana
    }
    'ELK'      : {
      elk::elasticsearch { $cluster_name:
        role    => $elk,
        master  => true,
        data    => true,
        cors    => false,
        parity  => 0,
        unicast => $::ipaddress,
        path    => '/usr/share/elasticsearch/data',
      }
      include elk::haproxy
      include elk::rabbitmq
      include elk::logstash
      include elk::kibana
    }
    default    : {
      notify { "elk_role2_default": message => 'Your ELK host has no $::role2' }
    }
  }
}
