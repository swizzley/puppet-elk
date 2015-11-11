# class elk::params
#
class elk::params {
  # Options
  $use_haproxy = true
  $cluster = true

  # Global Vars
  $vagrant_fullstack = 'elks-vg-v1d'
  $vagrant_cluster = ['elk-vg-v1d', 'log-vg-v1d', 'log-vg-v2d', 'kib-vg-v1d', 'kib-vg-v2d', 'elkq-vg-v1d', 'elkq-vg-v2d', 
      'es-vg-v1d', 'es-vg-v2d', 'es-vg-v3d' ]
      
  case $::fqdn {
    /.*-vg-.*/   : { $location = 'VG' } # Vagrant Test Environment
    default      : { $location = undef }
  }    
  
  case $::fqdn {
    /es-vg-v.d.*/   : {
      $elk = 'Elastic'
    }
    /log-vg-v.d/   : {
      $elk = 'Logstash'
    }
    /kib-vg-v.d.*/   : {
      $elk = 'Kibana'
    }
    /elkq-vg-v.d.*/  : {
      $elk = 'MQ'
    }
    /elk-vg-v.d.*/   : {
      $elk = 'Proxy'
    }
    $vagrant_cluster   : {
      if $cluster = true {
        fail('sorry cant cluster a single instance')
      } else {
        $elk = 'ELK'
      }
    }
    default : {
      fail('you need to specify the ELK roles')
    }
  }

  # Elasticsearch Vars
  $elasticsearch_version = '1.7.1'
    case $location {
    'VG'   : { 
                $cluster_name = 'vagrant'
                $es_cluster = grep($vagrant_cluster, 'es')
                $es_unicast_ip = '10.0.2.19, 10.0.2.20, 10.0.2.21'
                $pvt_key = 'puppet:///elk/logstash-forwarder-vagrant.key'
                $log_cluster = grep($vagrant_cluster, 'log')
                $log_cluster_ips = ['10.0.2.15', '10.0.2.16']
                $logstash_mq = grep($vagrant_cluster, 'elkq')
                $logstash_mq_ips = ['10.0.2.17', '10.0.2.18']
                
    } # Vagrant 
    default      : { 
                $cluster_name = undef
                $es_cluster = undef
                $es_unicast_ip = undef
                $pvt_key = undef
                $patterns = undef
                $log_cluster = undef
                $logstash_mq = undef
    } # Default
  }    
  
  $es_master = values_at($es_cluster, 0)
  $c10k = values_at(reverse($es_cluster), 0)
  $es_unicast_ip = ''
  $es_url = "http://${es_master}:9200"
  $data_dir = '/var/lib/elasticsearch/data'
  if ($elasticsearch_version == '1.7.1'){
    $url_elasticsearch_plugin_hq = 'https://github.com/royrusso/elasticsearch-HQ/archive/v1.0.0.zip'
  }else {
     $url_elasticsearch_plugin_hq = 'https://github.com/royrusso/elasticsearch-HQ/archive/v2.0.3.zip'
  }

  # Logstash Vars
  $patterns = []

  # Kibana Vars
  $kibana_url = 'https://download.elastic.co/kibana/kibana/kibana-4.1.2-linux-x64.tar.gz'
  $kib_cluster = []
  $kib_cluster_ips = []

  # Logstash-Forwarder Vars
  $cert = 'puppet:///modules/elk/logstash-forwarder.crt'
  $paths = []
  $dead_time = ''
  $fields = {
  }

  # RabbitMQ Vars
  $rmq_cluster = []
  $erlang_cookie = ''
  $rmq_user = ''
  $rmq_pass = ''
  $rmq_admin = ''
  $rmq_key = ''
  $rmq_master = reverse(chomp(chomp(reverse(chomp(chomp(values_at($rmq_cluster, 0)))))))

}
