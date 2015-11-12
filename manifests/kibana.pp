# class elk::kibana
class elk::kibana {
  include elk::java
  class { 'kibana': 
    base_url => $::elk::kibana_url,
    es_url => $::elk::es_url
  }
}
