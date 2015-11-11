# Class: elk
#
# This module deploys the ELK stack in the best way
#
class elk ($elk = $::elk::params::elk, $cluster_name = $::elk::params::cluster_name) inherits ::elk::params {
  case $elk {
    'Elastic'  : {
      include elk::elastic_node
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
      notify { "elk_role2_default": message => 'Your ELK host has not been defined in elk::params' }
    }
  }
}
