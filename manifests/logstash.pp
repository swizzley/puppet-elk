# class ::elk::logstash
#
# # # # Filters can go in any order, so long as they are NOT FIRST OR LAST # # # #
# This filter is for processing SYSLOG files
# lumberjack-in should always have the LOWEST order number
# lumberjack-out should always have the HIGHEST order number
class elk::logstash (
  $rmq_user      = $::elk::rmq_user,
  $rmq_pass      = $::elk::rmq_pass,
  $rmq_admin     = $::elk::rmq_admin,
  $rmq_key       = $::elk::rmq_key,
  $vagrant       = $::elk::vagrant,) inherits ::elk::params {
  # Prerequisites
  include ::elk::java
  require ::elk::java
  class { '::logstash': 
      java_install => true,
      java_package => 'java-1.8.0-openjdk',
      package_url  => 'https://download.elastic.co/logstash/logstash/packages/centos/logstash-2.0.0-1.noarch.rpm',
  }
  #[TODO]include ::elk::logstash_patterns

  if ($::elk::elk == 'Logstash') {
    if ($::elk::vagrant == 'elk-vg-v1d'){
    $elk = $elk::vagrant
    logstash::configfile { 'fullstack-begin':
      order   => 01,
      content => template('elk/logstash-conf-fullstack-first.erb')
    }

    logstash::configfile { 'fullstack-end':
      order   => 02,
      content => template('elk/logstash-conf-fullstack-last.erb')
    }

    # cluster setup
    file { '/etc/logstash/elasticsearch.yaml':
      owner   => 'root',
      group   => 'root',
      mode    => '0664',
      content => template('elk/logstash-elasticsearch-yaml.erb')
    } ~> Service['logstash']
}
  } else {
    # This is for full-stack node to do testing in staging
    logstash::configfile { 'fullstack-begin':
      order   => 01,
      content => template('elk/logstash-conf-fullstack-first.erb')
    }

    logstash::configfile { 'filter-syslog':
      order   => 02,
      content => template('elk/filters/syslog.erb')
    }

    logstash::configfile { 'fullstack-end':
      order   => 03,
      content => template('elk/logstash-conf-fullstack-last.erb')
    }
  }

}
