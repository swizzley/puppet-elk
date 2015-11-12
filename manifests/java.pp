# class elk::java
#
class elk::java {
  package { ['java-1.6.0-openjdk', 'java-1.7.0-openjdk']: ensure => absent }

  class { '::java':
    distribution => 'jdk',
    version      => '8'
  }
}
