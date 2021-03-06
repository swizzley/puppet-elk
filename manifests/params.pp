# class elk::params
#
class elk::params {
  # Options
  $secure_install = false
  $use_hiera_for_secret_data = false
  $elasticsearch_version = '1.7.1'
  $data_dir = '/var/lib/elasticsearch/data'
  
  # Nodes
  $vagrant_fullstack = 'elks-vg-v0d'
  $vagrant_cluster = ['elk-vg-v1d', 'log-vg-v1d', 'log-vg-v2d', 'kib-vg-v1d', 'kib-vg-v2d', 'elkq-vg-v1d', 'elkq-vg-v2d', 
      'es-vg-v1d', 'es-vg-v2d', 'es-vg-v3d' ]
      
  # Data
    case $::hostname {
    /.*-vg-v[1-9]d$/   : { 
                $cluster_name = 'vagrant'
                $es_cluster = grep($vagrant_cluster, 'es')
                $es_cluster_ips = ['172.28.128.8', '172.28.128.9', '172.28.128.10']
                $es_unicast_ip = '172.28.128.8, 172.28.128.9, 172.28.128.10'
                $pvt_key = 'puppet:///modules/elk/logstash-forwarder-vagrant.key'
                $cert = 'puppet:///modules/elk/logstash-forwarder-vagrant.crt'
                $log_cluster = grep($vagrant_cluster, 'log')
                $log_cluster_ips = ['172.28.128.4', '172.28.128.5']
                $kib_cluster = grep($vagrant_cluster, 'kib')
                $kib_cluster_ips = ['172.28.128.11', '172.28.128.12']
                $logstash_mq = grep($vagrant_cluster, 'elkq')
                $logstash_mq_ips = ['172.28.128.6', '172.28.128.7']
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
    /^es-vg-v[1-9]d$/   : {
        $elk = 'Elastic'
      }
    /^log-vg-v[1-9]d$/  : {
        $elk = 'Logstash'
        $vagrant = 'elk-vg-v1d'
      }
    /^kib-vg-v[1-9]d$/   : {
        $elk = 'Kibana'
      }
    /^elkq-vg-v[1-9]d$/ : {
        $elk = 'MQ'
      }
    'elk-vg-v1d'   : {
        $elk = 'Proxy'
      }
    'elks-vg-v0d'   : {
        $elk = 'ELK'
      }
    default : {
        fail('you need to specify the ELK roles')
    }
  }
  
  # Elasticsearch
  $es_master = values_at($es_cluster, 0)
  $es_front = suffix($es_master, ".${::domain}")
  $c10k = values_at(reverse($es_cluster), 0)
  $es_url = "http://${es_master}:9200"
  
  # Logstash
  #$patterns = []

  # Logstash-Forwarder 
  $paths = []
  $dead_time = ''
  $fields = {
  }
  
  # RabbitMQ 
  if ($use_hiera_for_secret_data == true){
    $rmq_user = hiera('rmq_user')
    $rmq_admin = hiera('rmq_admin')
    $rmq_pass = hiera('rmq_pass')
    $rmq_key = hiera('rmq_key')
  }else {
    $rmq_user = 'rabbit'
    $rmq_admin = 'admin'
    $rmq_pass = 'password'
    $rmq_key = 'secret'
  }
  
  if $secure_install {
    $kibana_url = undef
    if ($elasticsearch_version == '1.7.1'){
      $url_elasticsearch_plugin_hq = undef
    }else {
      $url_elasticsearch_plugin_hq = undef
    }
  }else {
    # FUll URL $kibana_url = 'https://download.elastic.co/kibana/kibana/kibana-4.1.2-linux-x64.tar.gz'
    $kibana_url = 'https://download.elastic.co/kibana/kibana'
    if ($elasticsearch_version == '1.7.1'){
      $url_elasticsearch_plugin_hq = 'https://github.com/royrusso/elasticsearch-HQ/archive/v1.0.0.zip'
    }else {
      $url_elasticsearch_plugin_hq = 'https://github.com/royrusso/elasticsearch-HQ/archive/v2.0.3.zip'
    }
  }
  
}
