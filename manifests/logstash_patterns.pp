# class elk::logstash_patterns
#
class elk::logstash_patterns {
  logstash::patternfile { 'tomcat':
    source   => template('elk/patterns/tomcat.erb'),
    filename => 'tomcat'
  }
}