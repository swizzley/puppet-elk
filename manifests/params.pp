# class elk::params
#
class elk::params {
  # Options
  $secure_install = false
  $elasticsearch_version = '1.7.1'
  $data_dir = '/var/lib/elasticsearch/data'
  
  # Nodes
  $vagrant_fullstack = 'elks-vg-v0d'
  $vagrant_cluster = ['elk-vg-v1d', 'log-vg-v1d', 'log-vg-v2d', 'kib-vg-v1d', 'kib-vg-v2d', 'elkq-vg-v1d', 'elkq-vg-v2d', 
      'es-vg-v1d', 'es-vg-v2d', 'es-vg-v3d' ]
      
  # Data
    case $fqdn {
    /.*-vg-v[1-9]d$/   : { 
                $cluster_name = 'vagrant'
                $es_cluster = grep($vagrant_cluster, 'es')
                $es_unicast_ip = '10.0.2.19, 10.0.2.20, 10.0.2.21'
                $pvt_key = 'puppet:///modules/elk/logstash-forwarder-vagrant.key'
                $cert = 'puppet:///modules/elk/logstash-forwarder-vagrant.crt'
                $log_cluster = grep($vagrant_cluster, 'log')
                $log_cluster_ips = ['10.0.2.15', '10.0.2.16']
                $kib_cluster = grep($vagrant_cluster, 'kib')
                $kib_cluster_ips = ['10.0.2.22', '10.0.2.23']
                $logstash_mq = grep($vagrant_cluster, 'elkq')
                $logstash_mq_ips = ['10.0.2.17', '10.0.2.18']
                $erlang_cookie = 'LOGSTASHVAGRANTLOGST'
                $config = 'elk/rabbitmq.config.erb'
    } # Vagrant Cluster
   /.*-vg-v0d$/   : { 
                $cluster_name = 'vagrant'
                $logstash_mq = $::fqdn
                $es_cluster = ['localhost']
                $log_cluster = ['localhost']
                $logstash_mq_ips = ['127.0.0.1']
                $kib_cluster = ['localhost']
                $kib_cluster_ips = ['127.0.0.1']
                $full_stack = $vagrant_fullstack
    } #Vagrant Stand-Alone
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
  
  case $::hostname {
    $es_cluster   : {
        $elk = 'Elastic'
      }
    $log_cluster  : {
        $elk = 'Logstash'
      }
    $kib_cluster   : {
        $elk = 'Kibana'
      }
    $logstash_mq  : {
        $elk = 'MQ'
      }
    /elk-vg-v.d.*/   : {
        $elk = 'Proxy'
      }
    $fullstack   : {
        $elk = 'ELK'
      }
    default : {
        fail('you need to specify the ELK roles')
    }
  }
  
  $es_master = values_at($es_cluster, 0)
  $es_front = suffix($es_master, $::domain)
  $c10k = values_at(reverse($es_cluster), 0)
  $es_url = "http://${es_master}:9200"
  
  if $secure_install {
    $kibana_url = undef
    if ($elasticsearch_version == '1.7.1'){
      $url_elasticsearch_plugin_hq = undef
    }else {
      $url_elasticsearch_plugin_hq = undef
    }
  }else {
    $kibana_url = 'https://download.elastic.co/kibana/kibana/kibana-4.1.2-linux-x64.tar.gz'
    if ($elasticsearch_version == '1.7.1'){
      $url_elasticsearch_plugin_hq = 'https://github.com/royrusso/elasticsearch-HQ/archive/v1.0.0.zip'
    }else {
      $url_elasticsearch_plugin_hq = 'https://github.com/royrusso/elasticsearch-HQ/archive/v2.0.3.zip'
    }
  }

  # Logstash Patterns
  $patterns = []

  # Logstash-Forwarder 
  $paths = []
  $dead_time = ''
  $fields = {
  }

  # RabbitMQ 
  $rmq_user = hiera('rmq_user')
  $rmq_admin = hiera('rmq_admin')
  $rmq_pass = hiera('rmq_pass')
  $rmq_key = hiera('rmq_key')
}
