# class elk::java
#
class elk::java {
# This isn't working yet on puppetlabs-java
#package { ['java-1.6.0-openjdk', 'java-1.7.0-openjdk']: ensure => absent }
#  class { '::java':
#    distribution => 'oracle-jdk',
#    version      => '8'
#  }
  class { '::java':
    distribution => 'jre',
    version      => '7'
  }
}
