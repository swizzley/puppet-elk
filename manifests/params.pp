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
    /es-vg-v.d/   : {
      $elk = 'Elastic'
    }
    /log-vg-v.d/   : {
      $elk = 'Logstash'
    }
    /kib-vg-v.d/   : {
      $elk = 'Kibana'
    }
    /elkq-vg-v.d/  : {
      $elk = 'MQ'
    }
    /elk-vg-v.d/   : {
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
  $elasticsearch = ''
  $cluster_name = ''
  $es_cluster = []
  $es_master = values_at($es_cluster, 0)
  $c10k = values_at(reverse($es_cluster), 0)
  $es_unicast_ip = ''
  $es_url = "http://${elasticsearch}"
  $data_dir = ''
  $url_elasticsearch_plugin_hq = ''

  # Logstash Vars
  $pvt_key = 'puppet:///private/logstash-forwarder.key'
  $patterns = []
  $log_cluster = []
  $logstash_mq = ''

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
