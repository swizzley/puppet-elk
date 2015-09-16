# class elk::logstash
#
# # # # Filters can go in any order, so long as they are NOT FIRST OR LAST # # # #
# This filter is for processing SYSLOG files
# lumberjack-in should always have the LOWEST order number
# lumberjack-out should always have the HIGHEST order number
class elk::logstash (
  $es          = $::elk::params::es_front,
  $es_cluster  = $::elk::params::es_cluster,
  $logstash_mq = $::elk::params::logstash_mq,
  $rmq_user    = $::elk::params::elk_rmq_user,
  $rmq_pass    = $::elk::params::elk_rmq_pass,
  $rmq_admin   = $::elk::params::elk_rmq_admin,
  $rmq_key     = $::elk::params::elk_rmq_key,) inherits ::elk::params {
  # Prerequisites
  include elk::java
  require elk::java
  include ::logstash

  if ($::role2 == 'ELK') {
    if ($::profile == 'production') {
      # This is for the MQ Buffer hosts only
      logstash::configfile { 'lumberjack-MQ':
        order   => 01,
        content => template('elk/elk/logstash-conf-rabbitmq.erb')
      }
    } else {
      logstash::configfile { 'lumberjack-MQ':
        order   => 01,
        content => template('elk/elk/logstash-conf-fullstack.erb')
      }
    }
  } else {
    logstash::configfile { 'rabbitmq-in':
      order   => 01,
      content => template('elk/elk/logstash-conf-first.erb')
    }

    logstash::configfile { 'filter-syslog':
      order   => 03,
      content => template('elk/elk/logstash-filter-syslog.erb')
    }

    logstash::configfile { 'elasticsearch-out':
      order   => 04,
      content => template('elk/elk/logstash-conf-last.erb')
    }
    # cluster setup
    file_line { "elastic_cluster_defaults":
      line => 'LS_JAVA_OPTS="-Djava.io.tmpdir=${LS_HOME} -Des.config=/etc/logstash/elasticsearch.yaml"',
      path => '/etc/sysconfig/logstash'
    } ~> Service['logstash']

    file { '/etc/logstash/elasticsearch.yaml':
      owner   => 'root',
      group   => 'root',
      mode    => '0664',
      content => template('elk/logstash-elasticsearch-yaml.erb')
    } ~> Service['logstash']
  }

}