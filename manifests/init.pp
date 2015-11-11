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
    'MQ'      : {
      include elk::rabbitmq
    }
    'Proxy'      : {
      include elk::haproxy
    }
    'ELK'      : {
      include elk::full_stack
    }
    default    : {
      notify { "elk_role2_default": message => 'Your ELK host has not been defined in elk::params' }
    }
  }
}
