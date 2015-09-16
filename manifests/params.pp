# class elk::params
#
class elk::params {
  # Options
  $use_haproxy = true
  $cluster = true

  # Global Vars
  $foo = 'ALL'

  case $::foo {
    'bar'   : {
      $elk = 'Elastic'
    }
    'BAR'   : {
      $elk = 'Logstash'
    }
    'FOO'   : {
      $elk = 'Kibana'
    }
    'MOO'   : {
      $elk = 'MQ'
    }
    'poo'   : {
      $elk = 'Proxy'
    }
    'ALL'   : {
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
  $elasticsearch = ''
  $cluster_name = ''
  $es_cluster = []
  $es_master = values_at($es_cluster, 0)
  $c10k = values_at(reverse($es_cluster), 0)
  $es_unicast_ip = ''
  $es_url = "http://${elasticsearch}"
  $data_dir = ''

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