# class elk::full_stack
class elk::full_stack {
  elk::elasticsearch { 'ELK':
    master  => true,
    data    => true,
    cors    => false,
    parity  => 0,
    unicast => $::ipaddress,
    path    => '/usr/share/elasticsearch/data',
  }
  include ::elk::haproxy
  include ::elk::rabbitmq
  include ::elk::logstash
  include ::elk::java
  include ::kibana
}
